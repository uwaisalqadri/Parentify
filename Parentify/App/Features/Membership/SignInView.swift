//
//  SignInView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI
import GoogleSignIn

struct SignInView: View {

  @ObservedObject var presenter: MembershipPresenter
  @EnvironmentObject var googleAuthManager: GoogleAuthManager
  @AppStorage(Constant.isNewUser) private var isNewUser: Bool = true

  @State var email: String = ""
  @State var password: String = ""
  @State var isSelectRole: Bool = false
  @State private var loginError: Error?
  @State private var isShowAlert: Bool = false
  @State private var isLoggedIn: Bool = false

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

          Text("Masuk")
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
            if !email.isEmpty || !password.isEmpty {
              signInUser(email: email, password: password)
            } else {
              isShowAlert.toggle()
            }
          }) {
            HStack {
              Spacer()

              Text("Masuk")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold))

              Spacer()
            }
          }
          .padding(15)
          .cardShadow(backgroundColor: .purpleColor, cornerRadius: 15)
          .padding(.top, 67)

          Button(action: {
            googleAuthManager.signIn()
          }) {
            HStack {
              Spacer()

              Text("Masuk Dengan Google")
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
            message: Text("\(loginError?.localizedDescription ?? "Field tidak boleh kosong")"),
            dismissButton: .default(Text("Oke Sip!"))
          )
        }
        .onReceive(presenter.$loginState) { state in
          if case .error(let error) = state {
            loginError = error
            isShowAlert = true
          } else if case .success(let isSuccess) = state {
            isLoggedIn = isSuccess
            isShowAlert = false
          } else {
            isShowAlert = false
          }
        }
        .onReceive(googleAuthManager.$state) { state in
          if case .signedIn = state {
            guard let user = GIDSignIn.sharedInstance.currentUser else { return }
            email = user.profile?.email ?? ""
            isLoggedIn = true
          }
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
          router.routeHome()
        }

      }
    }
    .progressHUD(isShowing: $presenter.loginState.isLoading)
    .onTapGesture {
      hideKeyboard()
    }
    .onReceive(dismissSelectRole) { _ in
      isSelectRole = false
      presenter.loginState.value = true
    }
  }

  private func signInUser(email: String, password: String) {
    if isNewUser {
      isSelectRole.toggle()
      presenter.registerUser(email: email, password: password)
      isNewUser = false
    } else {
      presenter.loginUser(email: email, password: password)
    }
  }

}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve())
  }
}
