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

  func routeAssignmentGroup(isParent: Binding<Bool>, assignmentGroup: AssignmentGroup, onUploaded: (() -> Void)? = nil) -> AssignmentGroupView {
    return AssignmentGroupView(isParent: isParent, assignmentGroup: assignmentGroup, router: self, onUploaded: onUploaded)
  }

  func routeAssignmentDetail(assignmentId: String = "", assignmentType: AssigmnentType? = nil, onUploaded: (() -> Void)? = nil) -> AssignmentDetailView {
    return AssignmentDetailView(presenter: assembler.resolve(), assignmentId: assignmentId, assignmentType: assignmentType, onUploaded: onUploaded)
  }

}

