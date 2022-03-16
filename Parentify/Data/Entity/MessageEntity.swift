//
//  MessageEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import Firebase

struct MessageEntity: BodyCodable, Codable {

  enum CodingKeys: String, CodingKey {
    case id = "message_id"
    case message = "message"
    case role = "role"
    case sentDate = "sent_date_time"
  }

  var id: String?
  var message: String?
  var role: UserRoleEntity?
  var sentDate: String?

  init(id: String?, message: String?, role: UserRoleEntity?, sentDate: String?) {
    self.id = id
    self.message = message
    self.role = role
    self.sentDate = sentDate
  }
}
