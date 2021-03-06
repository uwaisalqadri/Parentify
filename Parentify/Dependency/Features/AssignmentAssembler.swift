//
//  AssignmentAssembler.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

protocol AssignmentAssembler {
  func resolve() -> AssignmentRouter
  func resolve() -> AssignmentPresenter

  func resolve() -> SFSymbolSource
}

extension AssignmentAssembler where Self: Assembler {

  func resolve() -> AssignmentRouter {
    return AssignmentRouter(assembler: self)
  }

  func resolve() -> AssignmentPresenter {
    return AssignmentPresenter(firebaseManager: resolve())
  }

  func resolve() -> SFSymbolSource {
    return SFSymbolSource()
  }
}
