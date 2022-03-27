//
//  Binding.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/26/22.
//

import SwiftUI

func ??<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
  return Binding(get: {
    binding.wrappedValue ?? fallback
  }, set: {
    binding.wrappedValue = $0
  })
}

extension Binding where Value == Bool {
  func not() -> Binding<Value> {
    Binding<Value>(
      get: { !self.wrappedValue },
      set: { self.wrappedValue = !$0 }
    )
  }

  static func &&(_ lhs: Binding<Bool>, _ rhs: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
      get: { lhs.wrappedValue && rhs.wrappedValue },
      set: {_ in }
    )
  }
}
