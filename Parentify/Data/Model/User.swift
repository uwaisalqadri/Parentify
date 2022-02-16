//
//  ProfileItem.swift
//  Celengan
//
//  Created by Uwais Alqadri on 2/11/22.
//

import SwiftUI

enum UserRole: String {
  case father = "father"
  case mother = "mother"
  case children = "kids"
}

struct User {
  static let initialize: User = User()

  var userId: String = ""
  var role: UserRole = .children
  var name: String = ""
  var email: String = ""
  var isTaskFinished: Bool = false
  var profilePict: UIImage = UIImage()
}
