//
//  Color+Ext.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import Foundation
import SwiftUI

extension Color {
  static let pinkColor = Color("PinkColor")
  static let softgrayColor = Color("SoftgrayColor")
  static let yellowColor = Color("YellowColor")
  static let blueColor = Color("BlueColor")
  static let purpleColor = Color("PurpleColor")
  static let lightPurpleColor = Color("LightPurpleColor")
  static let redColor = Color("RedColor")
  static let blackColor = Color("BlackColor")
  static let brownColor = Color("BrownColor")

  static func random() -> Color {
    let random = Int.random(in: 1..<7)
    switch random {
    case 1:
      return .yellowColor
    case 2:
      return .blueColor
    case 3:
      return .pinkColor
    case 4:
      return .lightPurpleColor
    case 5:
      return .brownColor
    case 6:
      return .redColor
    case 7:
      return .blackColor
    default:
      return .purpleColor
    }
  }
}

extension Color {
  func uiColor() -> UIColor {
    if #available(iOS 14.0, *) {
      return UIColor(self)
    }

    let components = self.components()
    return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
  }

  private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
    var hexNumber: UInt64 = 0
    var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

    let result = scanner.scanHexInt64(&hexNumber)
    if result {
      r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
      g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
      b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
      a = CGFloat(hexNumber & 0x000000ff) / 255
    }
    return (r, g, b, a)
  }
}

extension UIColor {

  func colorData() -> Data? {
    return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
  }
}

extension Data {
  func color() -> UIColor? {
    return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) as? UIColor
  }
}
