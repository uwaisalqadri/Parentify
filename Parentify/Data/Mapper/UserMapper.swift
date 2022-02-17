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
      password: password.orEmpty(),
      isParent: isParent ?? false,
      profilePict: UIImage(data: profilePict ?? Data()) ?? UIImage()
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
      password: password,
      isParent: isParent,
      profilePict: profilePict.pngData()
    )
  }
}
