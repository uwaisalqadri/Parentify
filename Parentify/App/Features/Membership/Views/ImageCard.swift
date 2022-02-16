//
//  ImageCard.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ImageCard: View {

  var profileImage = UIImage()
  var onChooseProfile: (() -> Void)? = nil

  var body: some View {
    Button(action: {
      onChooseProfile?()
    }) {
      HStack(alignment: .center) {
        Image(uiImage: profileImage)
          .resizable()
          .padding(6)
          .foregroundColor(.black)
          .cornerRadius(14)
      }
    }.cardShadow(cornerRadius: 14)
      .disabled(onChooseProfile == nil)
  }
}

struct ImageCard_Previews: PreviewProvider {
  static var previews: some View {
    ImageCard()
      .previewLayout(.fixed(width: 70, height: 70))
  }
}
