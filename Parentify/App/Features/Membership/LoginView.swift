//
//  LoginView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct LoginView: View {

  @ObservedObject var presenter: MembershipPresenter
  @AppStorage("isUserNew") var isUserNew: Bool = false

  @State var email: String = ""
  @State var password: String = ""
  @State var isSelectRole: Bool = false

  let router: MembershipRouter

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {

        ImageCard(profileImage: UIImage(named: "AppIcon")!)
          .frame(width: 66, height: 66)
          .padding(.bottom, 55)
          .padding(.top, 40)

        Text("Login")
          .font(.system(size: 35, weight: .bold))
          .padding(.bottom, 43)

        CommonTextField(
          placeholder: "Email",
          text: $email,
          image: UIImage(systemName: "envelope.fill")
        )
        .padding(.bottom, 17)

        CommonTextField(
          placeholder: "Password",
          text: $password,
          image: UIImage(systemName: "lock.fill")
        )

        Button(action: {
          if isUserNew {
            // TODO: select role, make profile and create user
            isSelectRole.toggle()
          } else {
            presenter.loginUser(email: email, password: password)
            //presenter.createUser(user: .init(userId: "838KNDNDKW", role: .children, name: "Uwais", email: email, password: password, isParent: false, profilePict: UIImage()))
          }
        }) {
          HStack {
            Spacer()

            Text("Login")
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .bold))

            Spacer()
          }
        }
        .padding(15)
        .cardShadow(backgroundColor: .purpleColor, cornerRadius: 15)
        .padding(.top, 67)

        Button(action: {
          // TODO: Login via Google
          print("Login via Google")
        }) {
          HStack {
            Spacer()

            Text("Google")
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .bold))

            Spacer()
          }
        }
        .padding(15)
        .cardShadow(backgroundColor: .redColor, cornerRadius: 15)
        .padding(.top, 17)

        Spacer()

      }
      .onAppear {
        if case .success(let state) = presenter.loginState {
          print("SUCCESS", state)
        }
      }
      .padding(.horizontal, 25)
      .showSheet(isPresented: $isSelectRole) {
        let _: SelectRoleView = router.route { role in
          print("ROLE", role)
        }
      }

    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve())
  }
}
