//
//  AttachUserView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/20/22.
//

import SwiftUI

struct AttachUserView: View {

  var users = [User]()

  var onSelectUser: ((User) -> Void)?
  var onAttachUser: (() -> Void)?
  var onDetachUser: ((Int) -> Void)?

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(Array(users.enumerated()), id: \.offset) { index, user in
          ZStack(alignment: .bottomTrailing) {
            Image(uiImage: user.profilePict)
              .resizable()
              .frame(width: 32, height: 32)
              .cardShadow(cornerRadius: 8)
              .onTapGesture {
                onSelectUser?(user)
              }

            Image(systemName: "xmark.circle.fill")
              .resizable()
              .foregroundColor(.redColor)
              .frame(width: 15, height: 15)
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
            .frame(width: 32, height: 32)
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
