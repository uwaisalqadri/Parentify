//
//  Query.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/14/22.
//

import Foundation
import Firebase

enum FirebaseRecordDate: String {
  case assignment = "date_created"
  case chat = "sent_date"
  case message = "datetime"
}

extension Query {
  func newWhere(recordDate: FirebaseRecordDate) -> Query {
    let dateData = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    guard let today = Calendar.current.date(from: dateData),
          let end = Calendar.current.date(byAdding: .hour, value: 24, to: today),
          let start = Calendar.current.date(byAdding: .day, value: 2, to: today) else {
            fatalError("No records found in the specified range")
          }

    print("OKEOKE", recordDate.rawValue, end.toTimestamp(), today.toTimestamp())
    return whereField(recordDate.rawValue, isLessThanOrEqualTo: end.toTimestamp())
      .whereField(recordDate.rawValue, isGreaterThanOrEqualTo: today.toTimestamp())
  }
}
