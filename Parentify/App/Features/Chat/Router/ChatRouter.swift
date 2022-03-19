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

  func routeChat(currentUser: User, sender: User, assignment: Assignment = .empty, section: ChatChannelSection) -> ChatView {
    return ChatView(presenter: assembler.resolve(), membershipPresenter: assembler.resolve(), section: section, assignment: assignment, currentUser: currentUser, sender: sender)
  }

  func routeChatChannel(assignment: Assignment = .empty) -> ChatChannelView {
    return ChatChannelView(presenter: assembler.resolve(), membershipPresenter: assembler.resolve(), assignment: assignment, router: self)
  }

  func routeProfile(user: User) -> ProfileView {
    let router: MembershipRouter = assembler.resolve()
    return router.routeProfile(user: user)
  }

}
