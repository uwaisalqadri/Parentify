//
//  Dummies.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

func getChats() -> [Chat] {
  return [
    .init(id: "IJD292NE2K", sender: .initialize, message: "Udah dikerjain nak?", sentDate: Date(), seenBy: []),
    .init(id: "OMEDD8W99W", sender: .initialize, message: "Nanti klo udah selesai di kumpulin ke guru ya", sentDate: Date(), seenBy: []),
    .init(id: "903033MDDL", sender: .initialize, message: "Aman ma", sentDate: Date(), seenBy: []),
    .init(id: "IJD292NE2K", sender: .initialize, message: "Udah dikerjain nak?", sentDate: Date(), seenBy: []),
    .init(id: "OMEDD8W99W", sender: .initialize, message: "Nanti klo udah selesai di kumpulin ke guru ya", sentDate: Date(), seenBy: []),
    .init(id: "903033MDDL", sender: .initialize, message: "Aman ma", sentDate: Date(), seenBy: [])
  ]
}

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
