//
//  UserMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import SwiftUI

extension UserEntity {
  func map() -> User {
    return User(
      userId: userId.orEmpty(),
      role: UserRole(rawValue: role?.rawValue ?? "")!,
      name: name.orEmpty(),
      email: email.orEmpty(),
      isParent: isParent ?? false,
      profilePict: profilePict?.toImage() ?? UIImage(),
      lastChat: lastChat.orEmpty()
    )
  }
}

extension User {
  func map() -> UserEntity {
    return UserEntity(
      userId: userId,
      role: UserRoleEntity(rawValue: role.rawValue),
      name: name,
      email: email,
      isParent: isParent,
      profilePict: profilePict.toJpegString(compressionQuality: 0.5),
      lastChat: lastChat
    )
  }
}
