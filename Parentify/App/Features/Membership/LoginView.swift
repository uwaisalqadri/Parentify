//
//  LoginView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct LoginView: View {

  @ObservedObject var presenter: MembershipPresenter
  @AppStorage(Constant.isNewUser) private var isNewUser: Bool = true

  @State var email: String = ""
  @State var password: String = ""
  @State var isSelectRole: Bool = false
  @State private var loginError: Error?
  @State private var isShowAlert: Bool = false

  let router: MembershipRouter

  private let dismissSelectRole = NotificationCenter.default.publisher(for: Notifications.dismissSelectRole)

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {

          ImageCard(profileImage: UIImage(named: "AppIcon")!)
            .frame(width: 66, height: 66)
            .padding(.bottom, 55)
            .padding(.top, 30)

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
            if isNewUser {
              isSelectRole.toggle()
              presenter.registerUser(email: email, password: password)
              isNewUser = false
            } else {
              presenter.loginUser(email: email, password: password)
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
        .padding(.horizontal, 25)
        .showSheet(isPresented: $isSelectRole) {
          router.routeSelectRole(email: email, password: password) { role in
            print("JEJEJE", role)
          }
        }
        .alert(isPresented: $isShowAlert) {
          Alert(
            title: Text("Gagal"),
            message: Text("\(loginError?.localizedDescription ?? "")"),
            dismissButton: .default(Text("Oke Sip!"))
          )
        }
        .onReceive(presenter.$loginState) { state in
          if case .error(let error) = state {
            loginError = error
            isShowAlert.toggle()
          }
        }
        .fullScreenCover(isPresented: $presenter.loginState.value ?? false) {
          router.routeHome()
        }

      }
    }
    .onTapGesture {
      hideKeyboard()
    }
    .onAppear {
      //isSelectRole = presenter.isSuccessRegister
    }
    .onReceive(dismissSelectRole) { _ in
      isSelectRole = false
      presenter.loginState.value = true
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve())
  }
}
