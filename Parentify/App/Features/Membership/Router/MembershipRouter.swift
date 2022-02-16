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
    return ProfileView()
  }

  func route() -> MessagesView {
    return MessagesView()
  }

}
