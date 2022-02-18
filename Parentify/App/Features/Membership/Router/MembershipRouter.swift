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

  func route() -> ProfileView {
    return ProfileView(presenter: assembler.resolve())
  }

  func route() -> MessagesView {
    return MessagesView()
  }

  func route() -> LoginView {
    return LoginView(presenter: assembler.resolve(), router: self)
  }

  func route(onSelectRole: @escaping ((UserRole) -> Void)) -> SelectRoleView {
    return SelectRoleView(onSelectRole: onSelectRole)
  }

}
