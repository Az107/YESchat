//
//  ContentView.swift
//  YES
//
//  Created by Alberto Ruiz on 1/6/23.
//

import SwiftUI


struct ContentView: View {
    @State var messageInput = "";
    @State private var showingAlert = true
    @State private var name = ""
    @ObservedObject var messageEngine: MessageEngine = MessageEngine(userName: "test")
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("SI chat")
            ScrollViewReader { proxy in
                List(messageEngine.messages) {
                    message in
                    if message.sender == messageEngine.user {
                        HStack {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }.id(message.id)
                    } else {
                        HStack {
                            Text(message.content)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Spacer()
                        }.id(message.id)
                    }
                }.frame(maxHeight: .infinity)
                    .listStyle(.plain).onChange(of: messageEngine.messages) { newMessage in
                        proxy.scrollTo(newMessage.last?.id)
                    }
            }
            HStack {
                TextField("Message",text: $messageInput).textFieldStyle(.roundedBorder)
                if (messageInput.count == 0) {
                    Button {
                        
                    } label: {
                        Image(systemName: "paperclip")
                    }
                }
                Button {
                    messageEngine.send(messageInput, sender: messageEngine.user)
                    messageInput = "";
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
