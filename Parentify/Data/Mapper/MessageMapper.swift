//
//  MessageMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import SwiftUI

extension MessageEntity {
  func map() -> Message {
    return Message(
      id: UUID(uuidString: id.orEmpty()) ?? UUID(),
      message: message.orEmpty(),
      role: UserRole(rawValue: role?.rawValue ?? "")!,
      sentDate: sentDate?.toDate() ?? Date()
    )
  }
}

extension Message {
  func map() -> MessageEntity {
    return MessageEntity(
      id: id.uuidString,
      message: message,
      role: UserRoleEntity(rawValue: role.rawValue),
      sentDate: String(sentDate.timeIntervalSince1970)
    )
  }
}
