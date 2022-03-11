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

  func routeAssignmentGroup(isParent: Binding<Bool>, assignmentType: AssigmnentType, onUploaded: (() -> Void)? = nil) -> AssignmentGroupView {
    return AssignmentGroupView(presenter: assembler.resolve(), isParent: isParent, assignmentType: assignmentType, router: self, onUploaded: onUploaded)
  }

  func routeAssignmentDetail(assignmentId: String = "", assignmentType: AssigmnentType = .additional, onUploaded: (() -> Void)? = nil) -> AssignmentDetailView {
    return AssignmentDetailView(presenter: assembler.resolve(), assignmentId: assignmentId, assignmentType: assignmentType, onUploaded: onUploaded)
  }

}

