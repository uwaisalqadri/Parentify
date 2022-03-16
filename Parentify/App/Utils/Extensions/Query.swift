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
  case message = "sent_date_time"
}

extension Query {
  func orderByDate(recordDate: FirebaseRecordDate, descending: Bool = false) -> Query {
    return self.order(by: recordDate.rawValue, descending: descending)
  }
}
