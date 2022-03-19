//
//  UserEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import Foundation

enum UserRoleEntity: String, Codable {
  case father = "father"
  case mother = "mother"
  case children = "children"
}

class UserEntity: Codable, BodyCodable {

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case role = "role"
    case name = "name"
    case email = "email"
    case password = "password"
    case isParent = "is_parent"
    case profilePict = "profile_pict"
    case lastChat = "last_chat"
  }

  var userId: String?
  var role: UserRoleEntity?
  var name: String?
  var email: String?
  var password: String?
  var isParent: Bool?
  var profilePict: String?
  var lastChat: String?

  init(userId: String?, role: UserRoleEntity?, name: String?, email: String?, password: String?, isParent: Bool?, profilePict: String?, lastChat: String?) {
    self.userId = userId
    self.role = role
    self.name = name
    self.email = email
    self.password = password
    self.isParent = isParent
    self.profilePict = profilePict
    self.lastChat = lastChat
  }
}
