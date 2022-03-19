//
//  Dummies.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

func getMessages() -> [Message] {
  return [
    .init(message: "Jangan lupa ngerjain PR ya bil, udah ditagih sama bu guru Fatimah", role: .mother),
    .init(message: "Video English nya dikerjain bil, dicicil 1,5 jam 2x aja, nnti di merge di trus upload ke youtube", role: .father)
  ]
}

func getAssignmentGroups(assignments: [Assignment]) -> [AssignmentGroup] {
  return [
    .init(title: "Perlu Dikerjakan", type: .needToDone, assignments: assignments.filter { $0.type == .needToDone }),
    .init(title: "Tambahan", type: .additional, assignments: assignments.filter { $0.type == .additional })
  ]
}
