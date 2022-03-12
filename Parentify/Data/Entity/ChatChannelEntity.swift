//
//  ChatChannelEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/12/22.
//

import SwiftUI

struct ChatChannelEntity {

  enum CodingKeys: String, CodingKey {
    case chats = "chats"
    case users = "users"
    case isGroupChat = "is_group_chat"
  }

  var chats: [ChatEntity]?
  var users: [UserEntity]?
  var isGroupChat: Bool?

  init(chats: [ChatEntity]?, users: [UserEntity]?, isGroupChat: Bool?) {
    self.chats = chats
    self.users = users
    self.isGroupChat = isGroupChat
  }
}
