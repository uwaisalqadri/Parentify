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

  func route(assignmentGroup: AssignmentGroup) -> AssignmentGroupView {
    return AssignmentGroupView(assignmentGroup: assignmentGroup, router: self)
  }

  func route() -> AssignmentDetailView {
    return AssignmentDetailView()
  }

}

