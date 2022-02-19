//
//  MembershipRouter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MembershipRouter {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func routeProfile(isNewUser: Bool, user: User) -> ProfileView {
    return ProfileView(presenter: assembler.resolve(), isNewUser: isNewUser, profile: user)
  }

  func routeMessages() -> MessagesView {
    return MessagesView()
  }

  func routeLogin() -> LoginView {
    return LoginView(presenter: assembler.resolve(), router: self)
  }

  func routeHome() -> HomeView {
    let router: HomeRouter = assembler.resolve()
    return router.routeHome()
  }

  func routeSelectRole(email: String, password: String, onSelectRole: @escaping ((UserRole) -> Void)) -> SelectRoleView {
    return SelectRoleView(email: email, password: password, onSelectRole: onSelectRole, router: self)
  }

}
