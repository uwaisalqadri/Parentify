//
//  ProgressHUDModifier.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/18/22.
//

import SwiftUI

enum ProgressHUDType {
  case `default`
  case success
  case error
  case info
}

struct ProgressHUDModifier<Presenting>: View where Presenting: View {

  @Binding var isShowing: Bool
  let type: ProgressHUDType
  let isBlurBackground: Bool
  let presenting: () -> Presenting

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {

        presenting()
          .blur(radius: (isShowing && isBlurBackground) ? 1 : 0)

        VStack {
          switch type {
          case .default:
            if #available(iOS 14.0, *) {
              ProgressView()
                .frame(width: 40, height: 40, alignment: .center)
            } else {
              ActivityIndicator(isAnimating: .constant(true), style: .large)
                .frame(width: 50, height: 50, alignment: .center)
            }

          case .success:
            Image(systemName: "checkmark")
              .resizable()
              .frame(width: 30, height: 30)

          case .error:
            Image(systemName: "xmark")
              .resizable()
              .frame(width: 30, height: 30)
              .padding(.leading, 16)
              .padding(.trailing, 16)

          case .info:
            Image(systemName: "info.circle")
              .resizable()
              .frame(width: 30, height: 30)
          }
        }
        .padding()
        .background(BlurView(style: .systemThickMaterialLight))
        .foregroundColor(Color.primary)
        .cornerRadius(10)
        .opacity(isShowing ? 1 : 0)
      }
    }
  }
}


extension View {
  func progressHUD(
    isShowing: Binding<Bool>,
    type: ProgressHUDType = .default,
    isBlurBackground: Bool = true
  ) -> some View {
    ProgressHUDModifier(
      isShowing: isShowing,
      type: type,
      isBlurBackground: isBlurBackground,
      presenting: { self }
    )
  }
}
