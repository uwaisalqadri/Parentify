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

func getAssignmentGroups(assignments: [Assignment]) -> [AssignmentGroup] {
  return [
    .init(title: "Perlu Dikerjakan", assignments: assignments),
    .init(title: "Tambahan", assignments: assignments)
  ]
}
