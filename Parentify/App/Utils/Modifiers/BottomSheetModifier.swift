//
//  BottomSheetModifier.swift
//  Celengan
//
//  Created by Uwais Alqadri on 1/30/22.
//

import SwiftUI
import BottomSheet

struct BottomSheetModifier<ContentView: View>: ViewModifier {
  @Binding var isPresented: Bool
  var contentView: () -> ContentView

  func body(content: Content) -> some View {
    if #available(iOS 15, *) {
      content
        .bottomSheet(isPresented: $isPresented, prefersGrabberVisible: true, prefersEdgeAttachedInCompactHeight: false, contentView: contentView)
    } else {
      content
        .sheet(isPresented: $isPresented, content: contentView)
    }
  }
}

extension View {
  func showSheet<ContentView: View>(isPresented: Binding<Bool>, @ViewBuilder contentView: @escaping () -> ContentView) -> some View {
    modifier(BottomSheetModifier(isPresented: isPresented, contentView: contentView))
  }
}
