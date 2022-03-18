//
//  ChatEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/12/22.
//

import SwiftUI
import Firebase

struct ChatEntity: BodyCodable, Codable {

  enum CodingKeys: String, CodingKey {
    case id = "chat_id"
    case sender = "sender"
    case message = "message"
    case sentDate = "sent_date"
    case seenBy = "seen_by"
  }

  var id: String?
  var sender: UserEntity?
  var message: String?
  var sentDate: String?
  var isRead: Bool?
  var assignment: AssignmentEntity?
  var seenBy: [UserEntity]?

  init(id: String?, sender: UserEntity?, message: String?, sentDate: String?, isRead: Bool?, assignment: AssignmentEntity?, seenBy: [UserEntity]?) {
    self.id = id
    self.sender = sender
    self.message = message
    self.sentDate = sentDate
    self.isRead = isRead
    self.assignment = assignment
    self.seenBy = seenBy
  }
}
