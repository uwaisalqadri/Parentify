//
//  Date+Ext.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import Foundation

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

  func dateOnly() -> Date {
    let comps = Calendar.current.dateComponents([.day, .month, .year], from: self)
    return Calendar.current.date(from: comps) ?? self
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

  func timeAgoSinceDate(numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = self < now ? self : now
    let latest =  self > now ? self : now

    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
    let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)

    if let year = components.year {
      if (year >= 2) {
        return "last seen \(year) years ago"
      } else if (year >= 1) {
        return stringToReturn(flag: numericDates, strings: ("1 year ago", "Last year"))
      }
    }

    if let month = components.month {
      if (month >= 2) {
        return "last seen \(month) months ago"
      } else if (month >= 2) {
        return stringToReturn(flag: numericDates, strings: ("1 month ago", "Last month"))
      }
    }

    if let weekOfYear = components.weekOfYear {
      if (weekOfYear >= 2) {
        return "last seen \(weekOfYear) months ago"
      } else if (weekOfYear >= 2) {
        return stringToReturn(flag: numericDates, strings: ("1 week ago", "Last week"))
      }
    }

    if let day = components.day {
      if (day >= 2) {
        return "last seen \(day) days ago"
      } else if (day >= 2) {
        return stringToReturn(flag: numericDates, strings: ("1 day ago", "Yesterday"))
      }
    }

    if let hour = components.hour {
      if (hour >= 2) {
        return "last seen \(hour) hours ago"
      } else if (hour >= 2) {
        return stringToReturn(flag: numericDates, strings: ("1 hour ago", "An hour ago"))
      }
    }

    if let minute = components.minute {
      if (minute >= 2) {
        return "last seen \(minute) minutes ago"
      } else if (minute >= 2) {
        return stringToReturn(flag: numericDates, strings: ("1 minute ago", "A minute ago"))
      }
    }

    if let second = components.second {
      if (second >= 3) {
        return "a few seconds ago"
      }else{
        return "Online"
      }
    }

    return ""
  }

  private func stringToReturn(flag:Bool, strings: (String, String)) -> String {
    if (flag){
      return "last seen \(strings.0)"
    } else {
      return "last seen \(strings.0)"
    }
  }
}


