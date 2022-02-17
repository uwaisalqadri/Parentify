//
//  MembershipAssembler.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

protocol MembershipAssembler {
  func resolve() -> MembershipRouter
  func resolve() -> MembershipPresenter

  func resolve() -> FirebaseManager
}

extension MembershipAssembler where Self: Assembler {

  func resolve() -> MembershipRouter {
    return MembershipRouter(assembler: self)
  }

  func resolve() -> MembershipPresenter {
    return MembershipPresenter(firebaseManager: resolve())
  }

  func resolve() -> FirebaseManager {
    return DefaultFirebaseManager()
  }
}
