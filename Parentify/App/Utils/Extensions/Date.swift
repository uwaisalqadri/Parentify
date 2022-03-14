//
//  Date.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import Firebase

extension Date {

  var string: String {
    get { self.toString() }
    set { self = newValue.toDate() }
  }

  func toString(format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale.init(identifier: "id")
    return dateFormatter.string(from: self)
  }

  func toTimestamp() -> Timestamp {
    return Timestamp(date: self)
  }

  func dateOnly() -> Date {
    let comps = Calendar.current.dateComponents([.day, .month, .year], from: self)
    return Calendar.current.date(from: comps) ?? self
  }

  func nextDate() -> Date {
    let calendar = Calendar.current
    return calendar.date(byAdding: .year, value: 1, to: self) ?? self
  }

  func reduceToMonthDayYear() -> Date {
    let calendar = Calendar.current
    let month = calendar.component(.month, from: self)
    let day = calendar.component(.day, from: self)
    let year = calendar.component(.year, from: self)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
  }
}


