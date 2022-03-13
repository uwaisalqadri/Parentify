//
//  Message.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import SwiftUI

struct Message {
  static let empty: Message = Message()

  var id = UUID()
  var message: String = ""
  var role: UserRole = .mother
  var datetime: Date = Date()
}
