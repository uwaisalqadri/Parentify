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

  @State var assignment: Assignment = .empty
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
      .onTapGesture {
        hideKeyboard()
      }

      if presenter.chatsState != .loading && chats.isEmpty {
        HStack(alignment: .center) {
          Spacer()

          VStack(alignment: .center) {
            Image(systemName: "message.and.waveform.fill")
              .resizable()
              .foregroundColor(.purpleColor)
              .frame(width: 70, height: 60)

            Text("Start a Chat")
              .font(.system(size: 20, weight: .semibold))
              .foregroundColor(.purpleColor)
          }

          Spacer()
        }
        .padding(.vertical, 60)
        .padding(.bottom, 150)
      }

      ChatInputField(text: $inputText) { text in
        presenter.uploadChat(
          chat: .init(
            sender: sender,
            message: text,
            sentDate: Date(),
            isRead: false,
            assignment: assignment,
            seenBy: []
          )
        )
      }

    }
    .navigationBarTitle(sender.name)
    .navigationBarTitleDisplayMode(.inline)
    .overlay(
      VStack {
        ImageMembersCard(members: [.empty, .empty, .empty])
          .frame(width: 100, height: 100)
          .padding(.trailing, 10)
          .padding(.top, 35)

      }.offset(x: 0, y: -80)
      , alignment: .topTrailing
    )
    .onAppear {
      presenter.fetchChats()
    }
    .onDisappear(perform: {
      presenter.stopChats()
    })
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
