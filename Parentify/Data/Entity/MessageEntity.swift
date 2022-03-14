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
    case datetime = "datetime"
  }

  var id: String?
  var message: String?
  var role: UserRoleEntity?
  var datetime: Timestamp?

  init(id: String?, message: String?, role: UserRoleEntity?, datetime: Timestamp?) {
    self.id = id
    self.message = message
    self.role = role
    self.datetime = datetime
  }
}
