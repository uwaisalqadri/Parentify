//
//  ChatChannelView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/13/22.
//

import SwiftUI

struct ChatChannelView: View {

  @ObservedObject var presenter: ChatPresenter
  @State var sender: User = .initialize

  let router: ChatRouter

  var body: some View {
    List(getChatChannel(), id: \.id) { chatChannel in
      NavigationLink(destination: router.routeChat()) {
        ChatChannelRow()
      }.buttonStyle(PlainButtonStyle())
    }
    .navigationTitle("Chat Channel")
    .onAppear {
      // TODO: Get chat channel
    }
  }
}

struct ChatChannelView_Previews: PreviewProvider {

  static var assembler: Assembler = AppAssembler()

  static var previews: some View {
    ChatChannelView(presenter: assembler.resolve(), router: assembler.resolve())
  }
}
