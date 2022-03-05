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
      ForEach(homePresenter.messagesState.value ?? [], id: \.id) { message in
        MessagesItemView(message: message)
      }
    }
    .navigationBarTitle("Pesan Penting")
    .onAppear {
      homePresenter.getMessages()
    }
  }
}
