//
//  String.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import SwiftUI

extension Optional where Wrapped == String {
  func orEmpty() -> String {
    return self ?? ""
  }
}

func ??<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
  return Binding(get: {
    binding.wrappedValue ?? fallback
  }, set: {
    binding.wrappedValue = $0
  })
}

extension String {

  var int: Int {
    get { Int(self) ?? 0 }
    set { self = String(newValue) }
  }

  var date: Date {
    get { self.toDate() }
    set { self = newValue.toString() }
  }

}

extension String {

  func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'")-> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale.init(identifier: "id_ID")
    let date = dateFormatter.date(from: self) ?? Date()
    return date
  }

  func toImage() -> UIImage? {
    if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
      return UIImage(data: data)
    }
    return nil
  }

  func isNumeric() -> Bool {
    guard self.count > 0 else { return false }
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    return Set(self).isSubset(of: nums)
  }
}

extension Int {
  var string: String {
    get { String(self) }
    set { self = Int(newValue) ?? 0 }
  }
}

