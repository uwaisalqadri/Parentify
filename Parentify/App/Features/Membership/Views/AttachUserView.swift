//
//  AttachUserView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/20/22.
//

import SwiftUI

struct AttachUserView: View {

  var users = [User]()
  var imageSize: CGFloat = 32

  var onSelectUser: ((User) -> Void)?
  var onAttachUser: (() -> Void)?
  var onDetachUser: ((Int) -> Void)?

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        let children = users.filter { !($0.isParent) || $0.role == .children }
        ForEach(Array(children.enumerated()), id: \.offset) { index, user in
          ZStack(alignment: .bottomTrailing) {
            Image(uiImage: user.profilePict)
              .resizable()
              .frame(width: imageSize, height: imageSize)
              .cardShadow(cornerRadius: 8)
              .onTapGesture {
                onSelectUser?(user)
              }

            Image(systemName: "xmark.circle.fill")
              .resizable()
              .foregroundColor(.redColor)
              .frame(width: imageSize == 32 ? 15 : 20, height: imageSize == 32 ? 15 : 20)
              .padding([.bottom, .trailing], -3)
              .onTapGesture {
                onDetachUser?(index)
              }
          }
        }

        Button(action: {
          onAttachUser?()
        }) {
          Image("ImgAttachUser")
            .resizable()
            .frame(width: imageSize, height: imageSize)
        }
      }
      .padding()
    }

  }
}

struct AttachUserView_Previews: PreviewProvider {
  static var previews: some View {
    AttachUserView()
      .previewLayout(.sizeThatFits)
  }
}
