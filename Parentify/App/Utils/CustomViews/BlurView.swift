//
//  BlurView.swift
//  Celengan
//
//  Created by Uwais Alqadri on 1/29/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
  @State var style: UIBlurEffect.Style = .systemUltraThinMaterialDark

  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
