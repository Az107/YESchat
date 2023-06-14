//
//  loginView.swift
//  YES
//
//  Created by Alberto Ruiz on 4/6/23.
//

import SwiftUI

struct loginView: View {
    @State var usernameInput = "";
    var body: some View {
        VStack {
            TextField("username" ,text: $usernameInput)
            NavigationLink(destination: ChatView(username: usernameInput)) {
                Text("Login")
            }
        }.padding()
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
