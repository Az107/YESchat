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
    let id = UUID()
}

func idGenerator() -> String {
    let randomNumber = Int.random(in: 1...9999)
    return String(format: "%04d", randomNumber)
}

class MessageEngine: ObservableObject {
    @Published var messages: [Message] = [];
    @Published var user: String;
    let manager = SocketManager(socketURL: URL(string: "http://localhost:5001")!, config: [.log(false), .compress])
    let socket : SocketIOClient
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

    }
}
