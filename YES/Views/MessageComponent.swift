//
//  MessageComponent.swift
//  YES
//
//  Created by Alberto Ruiz on 14/6/23.
//

import SwiftUI

struct MessageComponent: View {
    var message: Message
    var isOwn = false
    var isSystem = false
    init(_ message: Message, isOwn: Bool) {
        self.message = message
        self.isOwn = isOwn
        self.isSystem = message.sender == "system"
    }
    var body: some View {
        HStack {
            if ( isOwn || isSystem ) {Spacer()}
            if (message.file == nil) {
                Text(message.content)
                    .padding()
                    .background(isOwn ? Color.blue : isSystem ? Color.white : Color.gray)
                    .foregroundColor(isSystem ? Color.black : Color.white)
                    .cornerRadius(10)
            } else {
                HStack{
                    Button {
                        
                    } label: {
                        Image(systemName: "doc.fill")
                            .imageScale(.large).foregroundColor(.white)
                    }
                    Text(message.content).foregroundColor(.white)
                }.background(isOwn ? Color.blue : isSystem ? Color.white : Color.gray) .cornerRadius(10)
            }

            if (!isOwn || isSystem ) {Spacer()}
        }.id(message.id)
    }
}

struct MessageComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageComponent(Message(sender: "a", content: "Placeholder"), isOwn: false);
            MessageComponent(Message(sender: "a", content: "Placeholder"), isOwn: true)
            MessageComponent(Message(sender: "a", content: "Placeholder", file: Data()), isOwn: false);
            MessageComponent(Message(sender: "a", content: "Placeholder",file: Data()), isOwn: true)
        }
    }
}
