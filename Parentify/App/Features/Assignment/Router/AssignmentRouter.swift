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

  func routeAssignmentGroup(isParent: Binding<Bool>, assignmentGroup: AssignmentGroup) -> AssignmentGroupView {
    return AssignmentGroupView(isParent: isParent, assignmentGroup: assignmentGroup, router: self)
  }

  func routeAssignmentDetail() -> AssignmentDetailView {
    return AssignmentDetailView(presenter: assembler.resolve())
  }

}

