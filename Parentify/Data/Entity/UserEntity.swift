//
//  UserEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import SwiftUI

enum UserRoleEntity: String, Codable {
  case father = "father"
  case mother = "mother"
  case children = "kids"
}

class UserEntity: Codable, BodyCodable {

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case role = "role"
    case name = "name"
    case email = "email"
    case password = "password"
    case isTaskFinished = "is_task_finished"
    case profilePict = "profile_pict"
  }

  var userId: String?
  var role: UserRoleEntity?
  var name: String?
  var email: String?
  var password: String?
  var isTaskFinished: Bool?
  var profilePict: Data?

  init(userId: String?, role: UserRoleEntity?, name: String?, email: String?, password: String?, isTaskFinished: Bool?, profilePict: Data?) {
    self.userId = userId
    self.role = role
    self.name = name
    self.email = email
    self.password = password
    self.isTaskFinished = isTaskFinished
    self.profilePict = profilePict
  }
}
