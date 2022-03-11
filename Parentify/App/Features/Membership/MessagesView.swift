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
            MessagesItemView(message: message)
          }
        } else if case .loading = homePresenter.messagesState {
          ActivityIndicator(isAnimating: .constant(true), style: .large)
            .padding(.top, 40)
        }
      }

      if isParent {
        HStack {
          Spacer()

          Button(action: {
            isAddMessage.toggle()
          }) {
            VStack {
              Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding()
            }
            .cardShadow(backgroundColor: .purpleColor, cornerRadius: 30)
            .padding(20)
          }
        }
      }

    }
    .navigationBarTitle("Pesan Penting")
    .onAppear {
      homePresenter.getMessages()
    }
    .onReceive(homePresenter.$addMessageState) { state in
      if case .success = state {
        isAddMessage.toggle()
        homePresenter.getMessages()
      }
    }
    .customDialog(isShowing: $isAddMessage) {
      AddMessageDialog { textMessage in
        let role = membershipPresenter.userState.value?.role ?? .children
        homePresenter.addMessage(message: .init(message: textMessage, role: role, datetime: Date()))
      } onDismiss: {
        isAddMessage.toggle()
      }
    }
  }
}
