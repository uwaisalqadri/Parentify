//
//  ChatChannelEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/12/22.
//

import SwiftUI

struct ChatChannelEntity: Codable, BodyCodable {

  enum CodingKeys: String, CodingKey {
    case id = "channel_id"
    case channelName = "channel_name"
    case users = "users"
  }

  var id: String?
  var channelName: String?
  var users: [UserEntity]?

  init(id: String?, channelName: String?, users: [UserEntity]?) {
    self.id = id
    self.channelName = channelName
    self.users = users
  }
}
