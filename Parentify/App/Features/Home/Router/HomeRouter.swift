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

  func route() -> HomeView {
    return HomeView(router: self, assignmentRouter: assembler.resolve())
  }

  func routeToProfile() -> ProfileView {
    let router: MembershipRouter = assembler.resolve()
    return router.route()
  }

  func routeToChat() -> ChatView {
    let router: ChatRouter = assembler.resolve()
    return router.route()
  }

}
