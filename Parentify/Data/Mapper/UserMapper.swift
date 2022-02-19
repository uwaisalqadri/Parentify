//
//  UserMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import SwiftUI

extension UserEntity {
  func map() -> User {
    let profileData = profilePict?.data(using: .utf8)
    return User(
      userId: userId.orEmpty(),
      role: UserRole(rawValue: role?.rawValue ?? "")!,
      name: name.orEmpty(),
      email: email.orEmpty(),
      password: password.orEmpty(),
      isParent: isParent ?? false,
      profilePict: UIImage(data: profileData ?? Data()) ?? UIImage()
    )
  }
}

extension User {
  func map() -> UserEntity {
    let profileString = String(decoding: profilePict.pngData() ?? Data(), as: UTF8.self)
    return UserEntity(
      userId: userId,
      role: UserRoleEntity(rawValue: role.rawValue),
      name: name,
      email: email,
      password: password,
      isParent: isParent,
      profilePict: profileString
    )
  }
}
