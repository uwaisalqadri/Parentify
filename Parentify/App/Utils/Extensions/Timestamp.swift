//
//  Timestamp.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/13/22.
//

import Firebase
import FirebaseFirestoreSwift

extension Timestamp {
  func toDate() -> Date {
    let date = self.dateValue()
    return date
  }
}
