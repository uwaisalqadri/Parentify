//
//  View.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import SwiftUI

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
