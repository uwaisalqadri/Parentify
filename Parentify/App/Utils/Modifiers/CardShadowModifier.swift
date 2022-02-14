//
//  CardShadowModifier.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import SwiftUI

struct CardShadow: ViewModifier {
  var backgroundColor: Color = .white
  var cornerRadius: CGFloat
  var opacity: CGFloat
  var radius: CGFloat
  var x: CGFloat
  var y: CGFloat

  func body(content: Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(Color.gray.opacity(0.3), lineWidth: 0.8)
      )
      .background(
        backgroundColor
          .cornerRadius(cornerRadius)
          .shadow(color: .black.opacity(opacity), radius: radius, x: x, y: y)
      )
  }
}

extension View {
  func cardShadow(
    backgroundColor: Color = .white,
    cornerRadius: CGFloat,
    opacity: CGFloat = 0.1,
    radius: CGFloat = 6,
    x: CGFloat = 0,
    y: CGFloat = 4
  ) -> some View {
    modifier(
      CardShadow(
        backgroundColor: backgroundColor,
        cornerRadius: cornerRadius,
        opacity: opacity,
        radius: radius,
        x: x,
        y: y
      )
    )
  }
}

