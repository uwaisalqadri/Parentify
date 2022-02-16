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
  var isGroupChat: Bool = false
  var users: [User] = []
}

struct Chat {
  static let initialize: Chat = Chat()

  var id: String = ""
  var sender: User = .initialize
  var sentDate: Date = Date()
  var seenBy: [User] = []
}
