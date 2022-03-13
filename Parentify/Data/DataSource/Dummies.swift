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

func getChatChannel() -> [ChatChannel] {
  return [
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false),
    .init(chats: getChats(), users: [], isGroupChat: false)
  ]
}

func getChats() -> [Chat] {
  return [
    .init(sender: .initialize, message: "Udah dikerjain nak?", sentDate: Date(), seenBy: []),
    .init(sender: .initialize, message: "Nanti klo udah selesai di kumpulin ke guru ya", sentDate: Date(), seenBy: []),
    .init(sender: .initialize, message: "Aman ma", sentDate: Date(), seenBy: []),
    .init(sender: .initialize, message: "Udah dikerjain nak?", sentDate: Date(), seenBy: []),
    .init(sender: .initialize, message: "Nanti klo udah selesai di kumpulin ke guru ya", sentDate: Date(), seenBy: []),
    .init(sender: .initialize, message: "Aman ma", sentDate: Date(), seenBy: [])
  ]
}

func getAssignmentGroups(assignments: [Assignment]) -> [AssignmentGroup] {
  return [
    .init(title: "Perlu Dikerjakan", type: .needToDone, assignments: assignments.filter { $0.type == .needToDone }),
    .init(title: "Tambahan", type: .additional, assignments: assignments.filter { $0.type == .additional })
  ]
}
