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

  func routeChat(sender: User) -> ChatView {
    return ChatView(presenter: assembler.resolve(), sender: sender)
  }

  func routeChatChannel(sender: User) -> ChatChannelView {
    return ChatChannelView(presenter: assembler.resolve(), sender: sender, router: self)
  }

  func routeProfile(user: User) -> ProfileView {
    let router: MembershipRouter = assembler.resolve()
    return router.routeProfile(user: user)
  }

}
