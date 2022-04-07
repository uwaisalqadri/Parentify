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

  @State private var currentUser: User = .empty
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
      membershipPresenter.fetchUser()
    }
    .onDisappear {
      membershipPresenter.stopUser()
    }
    .onViewStatable(
      homePresenter.$addMessageState,
      onSuccess: { _ in
        isAddMessage.toggle()
        homePresenter.fetchMessages()
      }
    )
    .onViewStatable(
      membershipPresenter.$userState,
      onSuccess: { user in
        currentUser = user
      }
    )
    .toolbar {
      ToolbarItem {
        if currentUser.isParent {
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
        let role = currentUser.role
        homePresenter.addMessage(message: .init(message: textMessage, role: role, sentDate: Date()))
      } onDismiss: {
        isAddMessage.toggle()
      }
    }
  }
}
