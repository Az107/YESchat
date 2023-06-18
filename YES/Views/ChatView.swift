//
//  ContentView.swift
//  YES
//
//  Created by Alberto Ruiz on 1/6/23.
//

import SwiftUI


struct headerView: View {
    var body: some View {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundColor(.accentColor)
        Text("SI chat")
    }
}

struct ChatView: View {
    @State var messageInput = "";
    @State private var showingAlert = true
    @State private var isScrolling = false
    @State private var filePickerIsShowing = false
    @ObservedObject var messageEngine: MessageEngine
    init(username: String) {
        self.messageEngine = MessageEngine(userName: username)
    }
    
    var body: some View {
        VStack {
            headerView()
            ScrollViewReader { proxy in
                List(messageEngine.messages) {
                    message in
                    MessageComponent(message, isOwn: message.sender == messageEngine.user)
                }.frame(maxHeight: .infinity)
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .onChange(of: messageEngine.messages) { newMessage in
                        proxy.scrollTo(newMessage.last?.id )
                    }
            }
            HStack {
                TextField("Message",text: $messageInput).textFieldStyle(.roundedBorder).animation(.easeIn, value: $messageInput.wrappedValue.isEmpty)
                if (messageInput.isEmpty){
                    Button {
                        self.filePickerIsShowing.toggle()
                    } label: {
                        Image(systemName: "paperclip")
                    }.fileImporter(isPresented: $filePickerIsShowing, allowedContentTypes: [.item]) { result in
                        
                        switch result {
                        case .success(let Fileurl):
                            print(Fileurl)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            
                  
                Button {
                    if (messageInput.isEmpty) { return }
                    messageEngine.send(messageInput, sender: messageEngine.user)
                    messageInput = "";
                } label: {
                    Image(systemName: "arrow.up")
                }.buttonStyle(.borderedProminent).buttonBorderShape(.capsule)
            }.frame(alignment: .bottom)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(username: "")
    }
}
