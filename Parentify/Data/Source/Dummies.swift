//
//  Dummies.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

func getAssignmentGroups() -> [AssignmentGroup] {
  return [
    .init(id: "IJD292NE2K", title: "Perlu Dikerjakan", assignments: getAssignments()),
    .init(id: "ODKEMF8393", title: "Tambahan", assignments: getAssignments())
  ]
}

func getAssignments() -> [Assignment] {
  return [
    .init(id: "DIWIDW79E2", iconName: "plus", title: "Mencuci Baju", description: "Oke", dateCreated: Date(), attachments: [], assignedTo: []),
    .init(id: "DIWIDW79E2", iconName: "plus", title: "Mencuci Baju", description: "Oke", dateCreated: Date(), attachments: [], assignedTo: []),
    .init(id: "DIWIDW79E2", iconName: "plus", title: "Mencuci Baju", description: "Oke", dateCreated: Date(), attachments: [], assignedTo: [])
  ]
}
