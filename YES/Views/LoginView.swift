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
            VStack {
                Spacer()
                Image("SI_chat").resizable().frame(width: 100, height: 100).cornerRadius(10)
                Text("SI chat").font(.largeTitle).bold().foregroundColor(.white)
                Spacer()
                HStack{
                    TextField("username" ,text: $usernameInput).textFieldStyle(.roundedBorder)
                    Button {
                        //ChatView(username: usernameInput)
                    } label: {
                        Text("Login")
                    }.buttonStyle(.borderedProminent)
                }.padding().background(.white)
            }.background(.ultraThinMaterial)
        }.background(
            Image("california1")
        )
        
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
