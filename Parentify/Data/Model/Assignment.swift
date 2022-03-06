//
//  Assignment.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentGroup {
  static let initialize: Assignment = Assignment()

  var id: String = ""
  var title: String = ""
  var assignments: [Assignment] = []
}

struct Assignment {
  static let initialize: Assignment = Assignment()

  var id: String = ""
  var iconName: String = ""
  var title: String = ""
  var description: String = ""
  var type: String = ""
  var dateCreated: Date = Date()
  var attachments: [String] = []
  var assignedTo: [User] = []
}
