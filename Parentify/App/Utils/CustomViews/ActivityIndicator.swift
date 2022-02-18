//
//  ActivityIndicator.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

  @Binding var isAnimating: Bool
  let style: UIActivityIndicatorView.Style

  func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: style)
  }

  func updateUIView(_ activityIndicatorView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    isAnimating ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
  }
}
