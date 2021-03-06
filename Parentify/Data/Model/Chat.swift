//
//  Chat.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatChannel {

  static let empty: ChatChannel = ChatChannel()

  var id: UUID = UUID()
  var channelName: String = ""
  var users = [User]()
}

struct Chat {
  static let empty: Chat = Chat()

  var id: UUID = UUID()
  var sender: User = .empty
  var message: String = ""
  var sentDate: Date = Date()
  var isRead: Bool = false
  var channelName: String = ""
  var assignment: Assignment = .empty
  var seenBy = [User]()
}
