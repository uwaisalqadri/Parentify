//
//  ChatView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI
import Introspect

struct ChatView: View {

  @ObservedObject var presenter: ChatPresenter
  @State private var inputText: String = ""
  @State private var chats: [Chat] = []

  @State var sender: User = .empty

  var body: some View {
    VStack {
      ReverseScrollView {
        VStack {
          ForEach(chats, id: \.id) { data in
            ChatRow(chat: data, isSender: data.sender.userId == sender.userId) { chat in
              presenter.deleteChat(chat: chat)
            }
          }
        }
        .padding(.top, 25)
      }

      ChatInputField(text: $inputText) { text in
        presenter.uploadChat(
          chat: .init(
            sender: sender,
            message: text,
            sentDate: Date(),
            isRead: false,
            seenBy: []
          )
        )
      }

    }
    .navigationBarTitle(sender.name)
    .navigationBarTitleDisplayMode(.inline)
    .overlay(
      VStack {
        ImageCard(profileImage: sender.profilePict)
          .frame(width: 48, height: 48)
          .padding(.trailing, 20)
          .padding(.top, 35)
      }.offset(x: 0, y: -80)
      , alignment: .topTrailing
    )
    .onTapGesture {
      hideKeyboard()
    }
    .onAppear {
      presenter.fetchChats()
    }
    .onReceive(presenter.$chatsState) { state in
      if case .success(let data) = state {
        chats = data
      }
    }
    .onReceive(presenter.$uploadChatState) { state in
      if case .success = state {
        presenter.fetchChats()
      }
    }
    .onReceive(presenter.$deleteChatState) { state in
      if case .success = state {
        presenter.fetchChats()
      }
    }

  }
}

struct ChatView_Previews: PreviewProvider {

  static var assembler: Assembler = AppAssembler()

  static var previews: some View {
    ChatView(presenter: assembler.resolve())
  }
}
