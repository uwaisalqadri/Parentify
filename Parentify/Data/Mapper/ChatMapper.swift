//
//  ChatMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/12/22.
//

import SwiftUI

extension ChatChannelEntity {
  func map() -> ChatChannel {
    return ChatChannel(
      id: UUID(uuidString: id.orEmpty()) ?? UUID(),
      channelName: channelName.orEmpty(),
      users: users?.map { $0.map() } ?? []
    )
  }
}

extension ChatChannel {
  func map() -> ChatChannelEntity {
    return ChatChannelEntity(
      id: id.uuidString,
      channelName: channelName,
      users: users.map { $0.map() }
    )
  }
}

extension ChatEntity {
  func map() -> Chat {
    return Chat(
      id: UUID(uuidString: id.orEmpty()) ?? UUID(),
      sender: sender?.map() ?? .empty,
      message: message.orEmpty(),
      sentDate: sentDate?.toDate() ?? Date(),
      isRead: isRead ?? false,
      isGroupChat: isGroupChat ?? false,
      assignment: assignment?.map() ?? .empty,
      seenBy: seenBy?.map { $0.map() } ?? []
    )
  }
}

extension Chat {
  func map() -> ChatEntity {
    return ChatEntity(
      id: id.uuidString,
      sender: sender.map(),
      message: message,
      sentDate: String(sentDate.timeIntervalSince1970),
      isRead: isRead,
      isGroupChat: isGroupChat,
      assignment: assignment.map(),
      seenBy: seenBy.map { $0.map() }
    )
  }
}
