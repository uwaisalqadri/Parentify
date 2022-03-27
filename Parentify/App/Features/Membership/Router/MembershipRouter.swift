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

  func routeProfile(user: User) -> ProfileView {
    return ProfileView(presenter: assembler.resolve(), profile: user, router: self)
  }

  func routeMessages(isParent: Binding<Bool>) -> MessagesView {
    return MessagesView(homePresenter: assembler.resolve(), membershipPresenter: assembler.resolve(), isParent: isParent)
  }

  func routeSignIn() -> SignInView {
    return SignInView(presenter: assembler.resolve(), router: self)
  }

  func routeHome() -> HomeView {
    let router: HomeRouter = assembler.resolve()
    return router.routeHome()
  }

  func routeSelectRole(email: String, onSelectRole: @escaping ((UserRole) -> Void)) -> SelectRoleView {
    return SelectRoleView(email: email, onSelectRole: onSelectRole, router: self)
  }

}
