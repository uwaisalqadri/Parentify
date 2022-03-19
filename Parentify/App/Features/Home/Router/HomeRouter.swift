//
//  HomeRouter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct HomeRouter {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func routeHome() -> HomeView {
    return HomeView(membershipPresenter: assembler.resolve(), assignmentPresenter: assembler.resolve(), chatPresenter: assembler.resolve(), presenter: assembler.resolve(), router: self, assignmentRouter: assembler.resolve())
  }

  func routeProfile(isNewUser: Bool = false, user: User = .empty) -> ProfileView {
    let router: MembershipRouter = assembler.resolve()
    return router.routeProfile(isNewUser: isNewUser, user: user)
  }

  func routeMessages(isParent: Binding<Bool>) -> MessagesView {
    let router: MembershipRouter = assembler.resolve()
    return router.routeMessages(isParent: isParent)
  }

  func routeChatChannel() -> ChatChannelView {
    let router: ChatRouter = assembler.resolve()
    return router.routeChatChannel()
  }

}
