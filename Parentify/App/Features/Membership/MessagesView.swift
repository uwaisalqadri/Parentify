//
//  MessagesView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesView: View {

  @ObservedObject var homePresenter: HomePresenter

  var body: some View {
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
    .navigationBarTitle("Pesan Penting")
    .onAppear {
      homePresenter.getMessages()
    }
  }
}
