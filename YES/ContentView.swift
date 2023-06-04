//
//  ContentView.swift
//  YES
//
//  Created by Alberto Ruiz on 1/6/23.
//

import SwiftUI
import SocketIO
import CoreML

struct Message: Identifiable {
    let sender: String
    let content: String
    let id = UUID()
}

func encryptString(_ str: String, key: Int) -> String {
    var encrypted = ""
    for char in str {
        let charCode = char.asciiValue! + UInt8(key)
        let encryptedChar = String(UnicodeScalar(charCode))
        encrypted += encryptedChar
    }
    return encrypted
}


struct ContentView: View {
    @State var messageInput = "";
    @State var messages: [Message] = [];
    @State var user: String = "YO#0001";
    var connected: Bool = true;
    let manager = SocketManager(socketURL: URL(string: "http://localhost:5001")!, config: [.log(false), .compress])
    let socket : SocketIOClient
    let encryptDetectorModel: EncriptDetector_1
    
    
    init() {
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

        let result = try? self.encryptDetectorModel.prediction(text: "M[]_adJËpJJJJJJK")
        if (result != nil) { print(result!.label)}
        
      

        
 
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("SI chat")
            if (connected) {
                List(messages) {
                    message in
                       if message.sender == user {
                           HStack {
                               Spacer()
                               Text(message.content)
                                   .padding()
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                           }
                       } else {
                           HStack {
                               Text(message.content)
                                   .padding()
                                   .background(Color.gray)
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                               Spacer()
                           }
                       }
                }.frame(maxHeight: .infinity)
                    .listStyle(.plain)
            } else {
                ProgressView().frame(maxHeight: .infinity)
            }
            HStack {
                TextField("Message",text: $messageInput).textFieldStyle(.roundedBorder)
                Button {
                    if (connected) {
                        self.socket.emit("my event", self.user + ": " + messageInput)
                        let m = Message(sender: user, content: messageInput)
                        messages.append(m)
                        messageInput = "";
                    }
                } label: {

                    Image(systemName: "arrow.up")
                } .buttonStyle(.borderedProminent).buttonBorderShape(.capsule)
            }.frame(alignment: .bottom)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
