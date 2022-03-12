//
//  Notifications.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import Foundation

func createPublisher(for notification: NSNotification.Name) -> NotificationCenter.Publisher {
  return NotificationCenter.default.publisher(for: notification)
}

struct Notifications {
  static let dismissSelectRole = NSNotification.Name(rawValue: "dismissSelectRole")
}

extension NSNotification.Name {
  func post(with object: Any? = nil) {
    NotificationCenter.default.post(name: self, object: object)
  }
}

