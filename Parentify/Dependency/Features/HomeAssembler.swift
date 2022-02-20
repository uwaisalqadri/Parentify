//
//  HomeAssembler.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

protocol HomeAssembler {
  func resolve() -> HomeRouter
  func resolve() -> HomePresenter
}

extension HomeAssembler where Self: Assembler {

  func resolve() -> HomeRouter {
    return HomeRouter(assembler: self)
  }

  func resolve() -> HomePresenter {
    return HomePresenter(firebaseManager: resolve())
  }
}
