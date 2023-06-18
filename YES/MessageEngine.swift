//
//  MessageEngine.swift
//  YES
//
//  Created by Alberto Ruiz on 4/6/23.
//

import Foundation
import SocketIO
import CoreML

 struct Message: Identifiable, Equatable {
    let sender: String
    let content: String
    var file: Data? = nil
    let id = UUID()
    
    init(sender: String,content: String) {
        self.sender = sender
        self.content = content
    }
    
    init(sender: String, content: String, file: Data) {
        self.sender = sender
        self.file = file
        self.content = content
    }
}

func idGenerator() -> String {
    let randomNumber = Int.random(in: 1...9999)
    return String(format: "%04d", randomNumber)
}

let url = UserDefaults.standard.string(forKey: "url_preference") ?? "http://localhost:5001"

class MessageEngine: ObservableObject {
    @Published var messages: [Message] = [];
    @Published var user: String;
    let manager = SocketManager(socketURL: URL(string: url)!, config: [.log(false), .compress])
    let socket : SocketIOClient
    var bigChunkus = BigChunkus()
    let encryptDetectorModel: EncriptDetector_1
    
    func encryptString(_ str: String, key: Int) -> String {
        var encrypted = ""
        for char in str.unicodeScalars {
            let charCode = char.value + UInt32(key)
            let encryptedChar = String(UnicodeScalar(charCode)!)
            encrypted += encryptedChar
        }
        return encrypted
    }

    func decryptString(_ str: String, key: Int) -> String {
        var decrypted = ""
        for char in str.unicodeScalars {
            let charCode = char.value - UInt32(key)
            let decryptedChar = String(UnicodeScalar(charCode)!)
            decrypted += decryptedChar
        }
        return decrypted
    }
    
    func send(_ content: String, sender: String) {
        let m = Message(sender: sender, content: content)
        let content = encryptString(sender + ": " + content, key: 42)
        self.socket.emit("my event", content)
        messages.append(m)
    }
    
    init(userName: String) {
        self.user = userName + "#" + idGenerator()
        self.socket = self.manager.defaultSocket
        self.socket.connect()
        print(self.manager.status)
        self.encryptDetectorModel = {
            do {
                let mlConfig = MLModelConfiguration()
                return try EncriptDetector_1(configuration: mlConfig)
            } catch {
                print("error")
                fatalError("could not start EncriptDetector")
            }
      
        }()
        let url = UserDefaults.standard.string(forKey: "url_preference")
        print("url:" + (url ?? "error"))
        
        self.socket.on(clientEvent: .connect) {[weak self] _,_ in
            guard let self = self else {
                return
            }
            print("Login as " + userName)
            self.socket.emit("new user", userName)
        }

        self.socket.on("chat message") {[weak self] data,ack in
            guard let self = self else {
                return
            }
            let rawContent = data[0] as! String;
            let type = try? self.encryptDetectorModel.prediction(text: rawContent)
            print(">" + rawContent + "<")
            print(type?.label ?? "error determining message kind")
            var content = rawContent
            if (type?.label == "Encrypted") {
                content = decryptString(rawContent, key: 42)
                print(content)
                let type = try? self.encryptDetectorModel.prediction(text: content)
                print(type?.label ?? "error determining message kind")
            }
            let msgData = content.split(separator: ": ")
            if (msgData[0] != self.user) {
                self.messages.append(Message(sender: String(msgData[0]), content: String(msgData[1])))
            }

        }
        
        self.socket.on("broadcast adjunt") {[weak self] data,ack in
            guard let self = self else {
                return
            }
            let chunkData = data[0] as? [String: Any] ?? [:]
            if  let sender = chunkData["sender"] as? String,
                let name = chunkData["name"] as? String,
                let index = chunkData["index"] as? Int,
                let total = chunkData["total"] as? Int,
                let data = chunkData["chunk"] as? Data
            {
                let chunk = Chunk(sender: sender, name: name, index: index, total: total, chunk: data)

                let complete = try? self.bigChunkus.addChunk(chunk: chunk)
                    
                if (complete ?? false) {
                    let message = try? self.bigChunkus.unChunkerize()
                    if ( message != nil ) {
                        self.messages.append(message!)
                    } else {
                        self.bigChunkus.clear()
                    }
                }
            } else {
                    print("Data not valid")
            }
        
        }

    }
}
