//
//  ChatMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/12/22.
//

import SwiftUI

extension ChatEntity {
  func map() -> Chat {
    return Chat(
      id: UUID(uuidString: id.orEmpty()) ?? UUID(),
      sender: sender?.map() ?? .empty,
      message: message.orEmpty(),
      sentDate: sentDate?.toDate() ?? Date(),
      isRead: isRead ?? false,
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
      seenBy: seenBy.map { $0.map() }
    )
  }
}
