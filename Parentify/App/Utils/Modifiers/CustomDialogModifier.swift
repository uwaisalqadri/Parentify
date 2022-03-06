//
//  CustomDialogModifier.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/2/22.
//

import SwiftUI

struct CustomDialogView<DialogContent: View>: ViewModifier {
  @Binding var isShowing: Bool
  let dialogContent: DialogContent

  init(isShowing: Binding<Bool>, @ViewBuilder dialogContent: () -> DialogContent) {
    self._isShowing = isShowing
    self.dialogContent = dialogContent()
  }

  func body(content: Content) -> some View {
    ZStack {
      content
        .blur(radius: isShowing ? 1.5 : 0)
        .onTapGesture {
          isShowing.toggle()
        }

      if isShowing {
        ZStack {
          dialogContent
            .background(
              RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
            )
        }.padding(40)
      }
    }
  }
}

extension View {
  func customDialog<DialogContent: View>(
    isShowing: Binding<Bool>,
    @ViewBuilder dialogContent: @escaping () -> DialogContent
  ) -> some View {
    modifier(CustomDialogView(isShowing: isShowing, dialogContent: dialogContent))
  }
}
