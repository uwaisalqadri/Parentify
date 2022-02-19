//
//  SelectRoleView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import SwiftUI

struct SelectRoleView: View {

  @State var email: String = ""
  @State var password: String = ""
  @State private var isInputProfile: Bool = false
  @State private var selectedRole: UserRole = .children
  var onSelectRole: ((UserRole) -> Void)? = nil

  let router: MembershipRouter

  var body: some View {
    NavigationView {
      VStack {
        HStack(alignment: .center) {
          RoleOption(role: .father) {
            onSelectRole?(.father)
            selectedRole = .father
            isInputProfile.toggle()
          }
          .padding(.trailing, 70)

          RoleOption(role: .mother) {
            onSelectRole?(.mother)
            selectedRole = .mother
            isInputProfile.toggle()
          }
        }

        RoleOption(role: .children) {
          onSelectRole?(.children)
          selectedRole = .children
          isInputProfile.toggle()
        }
        .padding(.top, 40)

      }
      .background(
        NavigationLink(destination: router.routeProfile(isNewUser: true, user: .init(role: selectedRole, email: email, password: password)), isActive: $isInputProfile) {
          EmptyView()
        }
      )
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
    SelectRoleView(router: AppAssembler.shared.resolve())
  }
}
