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

  func routeAssignmentGroup(
    isParent: Bool,
    assignmentType: AssigmnentType,
    onUploaded: (() -> Void)? = nil
  ) -> AssignmentGroupView {
    return AssignmentGroupView(
      presenter: assembler.resolve(),
      membershipPresenter: assembler.resolve(),
      isParent: isParent,
      assignmentType: assignmentType,
      router: self,
      onUploaded: onUploaded)
  }

  func routeAssignmentDetail(
    isParent: Bool,
    assignmentId: String,
    assignmentType: AssigmnentType = .additional,
    onUploaded: (() -> Void)? = nil
  ) -> AssignmentDetailView {
    return AssignmentDetailView(
      presenter: assembler.resolve(),
      membershipPresenter: assembler.resolve(),
      router: self,
      isParent: isParent,
      assignmentId: assignmentId,
      assignmentType: assignmentType,
      onUploaded: onUploaded
    )
  }

  func routeChatChannel(assignment: Assignment = .empty) -> ChatChannelView {
    let router: ChatRouter = assembler.resolve()
    return router.routeChatChannel(assignment: assignment)
  }

}

