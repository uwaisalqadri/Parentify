//
//  SelectRoleView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import SwiftUI

struct SelectRoleView: View {

  var onSelectRole: ((UserRole) -> Void)? = nil

  var body: some View {
    VStack {
      HStack(alignment: .center) {
        RoleOption(role: .father) {
          onSelectRole?(.father)
        }
        .padding(.trailing, 70)

        RoleOption(role: .mother) {
          onSelectRole?(.mother)
        }
      }

      RoleOption(role: .children) {
        onSelectRole?(.children)
      }
      .padding(.top, 40)

    }
  }
}

struct RoleOption: View {

  var role: UserRole = .children
  var onSelectRole: (() -> Void)?

  var body: some View {
    Button(action: {
      onSelectRole?()
    }) {
      VStack {
        ImageCard()
          .frame(width: 93, height: 93)

        switch role {
        case .father:
          Text("Ayah")
            .foregroundColor(.black)
            .font(.system(size: 17, weight: .bold))
        case .mother:
          Text("Ibu")
            .foregroundColor(.black)
            .font(.system(size: 17, weight: .bold))
        case .children:
          Text("Anak")
            .foregroundColor(.black)
            .font(.system(size: 17, weight: .bold))
        }

      }
    }
  }
}

struct SelectRoleView_Previews: PreviewProvider {
  static var previews: some View {
    SelectRoleView()
  }
}
