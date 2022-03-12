//
//  Chat.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatChannel {
  static let initialize: ChatChannel = ChatChannel()

  var chats: [Chat] = []
  var users: [User] = []
  var isGroupChat: Bool = false
}

struct Chat {
  static let initialize: Chat = Chat()

  var id: UUID = UUID()
  var sender: User = .initialize
  var message: String = ""
  var sentDate: Date = Date()
  var isRead: Bool = false
  var seenBy: [User] = []
}
