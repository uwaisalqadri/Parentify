//
//  Notifications.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import Foundation

struct Notifications {
  static let dismissSelectRole = NSNotification.Name(rawValue: "dismissSelectRole")
}

public extension NSNotification.Name {
  func post(with object: Any? = nil) {
    NotificationCenter.default.post(name: self, object: object)
  }
}

