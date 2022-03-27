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
  @AppStorage(Constant.isUserExist) private var isUserExist: Bool = false

  @State var email: String = "uwaisalqadri@icloud.com"
  @State var password: String = "Wasweswos123"
  @State var isSelectRole: Bool = false
  @State private var signInError: Error?
  @State private var isShowAlert: Bool = false
  @State private var isSignedIn: Bool = false

  let router: MembershipRouter

  private let dismissSelectRole = createPublisher(for: Notifications.dismissSelectRole)

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
            presenter.fetchUsers()
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
          router.routeSelectRole(email: email) { role in
            print("JEJEJE", role)
          }
        }
        .alert(isPresented: $isShowAlert) {
          Alert(
            title: Text("Gagal"),
            message: Text("\(signInError?.localizedDescription ?? "Field tidak boleh kosong")"),
            dismissButton: .default(Text("Oke Sip!"))
          )
        }
        .onReceive(presenter.$allUserState) { state in
          if case .success(let data) = state {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
              let isMatchEmail = data.filter { $0.email == email }.count > 0
              signInUser(email: email, password: password, isUserExist: isMatchEmail)
            }
          }
        }
        .onReceive(presenter.$signInState) { state in
          if case .error(let error) = state {
            signInError = error
            isShowAlert = true
          } else if case .success(let isSuccess) = state {
            isSignedIn = isSuccess
            isShowAlert = false
          } else {
            isShowAlert = false
          }
        }
        .onReceive(googleAuthManager.$state) { state in
          if case .signedIn = state {
            guard let user = GIDSignIn.sharedInstance.currentUser else { return }
            email = user.profile?.email ?? ""
            isSignedIn = true
          }
        }
        .fullScreenCover(isPresented: $isSignedIn) {
          router.routeHome()
        }

      }
    }
    .progressHUD(isShowing: $presenter.allUserState.isLoading)
    .progressHUD(isShowing: $presenter.signInState.isLoading)
    .onTapGesture {
      hideKeyboard()
    }
    .onReceive(dismissSelectRole) { _ in
      isSelectRole = false
      isUserExist = true
      presenter.signInState.value = true
    }
  }

  private func signInUser(email: String, password: String, isUserExist: Bool) {
    if !isUserExist || signInError?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
      isSelectRole.toggle()
      presenter.registerUser(email: email, password: password)
    } else {
      presenter.signInUser(email: email, password: password)
      self.isUserExist = true
    }
  }

}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve())
  }
}
