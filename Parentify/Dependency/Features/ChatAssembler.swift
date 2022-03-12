//
//  ChatAssembler.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

protocol ChatAssembler {
  func resolve() -> ChatRouter
  func resolve() -> ChatPresenter
}

extension ChatAssembler where Self: Assembler {

  func resolve() -> ChatRouter {
    return ChatRouter(assembler: self)
  }

  func resolve() -> ChatPresenter {
    return ChatPresenter(firebaseManager: resolve())
  }
}
