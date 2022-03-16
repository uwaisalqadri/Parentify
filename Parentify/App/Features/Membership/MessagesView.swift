//
//  MessagesView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesView: View {

  @ObservedObject var homePresenter: HomePresenter
  @ObservedObject var membershipPresenter: MembershipPresenter
  @Binding var isParent: Bool

  @State var isAddMessage: Bool = false

  var body: some View {
    VStack(alignment: .center) {
      ScrollView {
        if case .success(let messages) = homePresenter.messagesState {
          ForEach(messages, id: \.id) { message in
            MessagesRow(message: message)
          }
        } else if case .loading = homePresenter.messagesState {
          ActivityIndicator(isAnimating: .constant(true), style: .large)
            .padding(.top, 40)
        }
      }
    }
    .navigationBarTitle("Pesan Penting")
    .onAppear {
      homePresenter.fetchMessages()
    }
    .onReceive(homePresenter.$addMessageState) { state in
      if case .success = state {
        isAddMessage.toggle()
        homePresenter.fetchMessages()
      }
    }
    .toolbar {
      ToolbarItem {
        if isParent {
          Button(action: {
            isAddMessage.toggle()
          }) {
            Image(systemName: "plus.bubble.fill")
              .foregroundColor(.purpleColor)
          }
        }
      }
    }
    .customDialog(isShowing: $isAddMessage) {
      AddMessageDialog { textMessage in
        let role = membershipPresenter.userState.value?.role ?? .children
        homePresenter.addMessage(message: .init(message: textMessage, role: role, sentDate: Date()))
      } onDismiss: {
        isAddMessage.toggle()
      }
    }
  }
}
