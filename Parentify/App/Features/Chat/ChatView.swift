//
//  ChatView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatView: View {

  @State var inputText: String = ""

  var body: some View {
    VStack {
      ScrollView {
        ForEach(getChats(), id: \.id) { chat in
          ChatItemView(chat: chat, isSender: chat.id == "903033MDDL")
        }
        .padding(.top, 25)
      }

      ChatInputField(text: $inputText) { text in
        print(text)
      }
    }
    .navigationBarTitle("Chat")
    .overlay(
      ImageCard()
        .frame(width: 48, height: 48)
        .padding(.trailing, 20)
        .offset(x: 0, y: -80)
      , alignment: .topTrailing
    )
    .onTapGesture {
      hideKeyboard()
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
