//
//  AssignmentRouter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentRouter {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func route() -> AssignmentGroupView {
    return AssignmentGroupView()
  }

  func route() -> AssignmentDetailView {
    return AssignmentDetailView()
  }

}

