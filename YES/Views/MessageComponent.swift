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
                Image(systemName: "doc")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }

            if (!isOwn || isSystem ) {Spacer()}
        }.id(message.id)
    }
}

struct MessageComponent_Previews: PreviewProvider {
    static var previews: some View {
        MessageComponent(Message(sender: "a", content: "Placeholder"), isOwn: false)
    }
}
