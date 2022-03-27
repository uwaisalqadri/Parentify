//
//  View.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import SwiftUI

extension View {

  static var screenWidth: CGFloat {
    get {
      if UIDevice.current.orientation.isLandscape {
        return max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
      } else {
        return min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
      }
    }
  }

  static var screenHeight: CGFloat {
    get {
      if UIDevice.current.orientation.isLandscape {
        return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
      } else {
        return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
      }
    }
  }

}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }

  func isIpad() -> Bool {
    UIDevice.current.userInterfaceIdiom == .pad
  }
}
