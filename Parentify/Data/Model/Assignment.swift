//
//  Assignment.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

enum AssigmnentType: String, CaseIterable {
  case needToDone = "need_to_done"
  case additional = "additional"
}

struct AssignmentGroup {
  static let initialize: AssignmentGroup = AssignmentGroup()

  var id: UUID = UUID()
  var title: String = ""
  var type: AssigmnentType = .additional
  var assignments: [Assignment] = []
}

struct Assignment {
  static let initialize: Assignment = Assignment()

  var id: UUID = UUID()
  var iconName: String = ""
  var title: String = ""
  var description: String = ""
  var type: AssigmnentType = .additional
  var dateCreated: Date = Date()
  var attachments: [String] = []
  var assignedTo: [User] = []
}
