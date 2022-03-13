//
//  ChatRouter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatRouter {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func routeChat(sender: User = .initialize) -> ChatView {
    return ChatView(presenter: assembler.resolve(), sender: sender)
  }

  func routeChatChannel() -> ChatChannelView {
    return ChatChannelView(presenter: assembler.resolve())
  }

  func routeProfile(user: User) -> ProfileView {
    let router: MembershipRouter = assembler.resolve()
    return router.routeProfile(user: user)
  }

}
