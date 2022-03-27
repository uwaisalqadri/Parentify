//
//  ProfileView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI
import Combine
import Firebase
import GoogleSignIn

struct ProfileView: View {

  @AppStorage(Constant.isUserExist) var isUserExist: Bool = false
  @EnvironmentObject var googleAuthManager: GoogleAuthManager
  @ObservedObject var presenter: MembershipPresenter

  @State var profile: User

  @State private var profileImage = UIImage()
  @State private var isShowMemojiTextView = false
  @State private var isShowEditProfile = true
  @State private var isShowDeveloper = false

  let router: MembershipRouter

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          ImageCard(profileImage: profileImage) {
            isShowMemojiTextView = true
          }
          .frame(width: 70, height: 70, alignment: .center)

          VStack(alignment: .leading) {
            Text(profile.name)
              .font(.system(size: 18, weight: .bold))

            Text(profile.email)
              .foregroundColor(.gray)
              .font(.system(size: 16, weight: .semibold))
          }.padding(.leading, 14)

          Spacer()
        }.padding([.leading, .top], 22)

        VStack {
          HStack {
            Text(isUserExist ? "Complete Profile" : "Edit Profile")
              .font(.system(size: 17, weight: .bold))

            Spacer()

            Dropdown(isExpand: $isShowEditProfile) {
              withAnimation {
                isShowEditProfile.toggle()
              }
            }
          }

          if isShowEditProfile {
            TextField("Name", text: $profile.name)
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.black)
              .padding(18)
              .autocapitalization(.none)
              .disableAutocorrection(true)
              .cardShadow(cornerRadius: 13)
              .padding(.top, 12)

            TextField("Email", text: $profile.email)
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.black)
              .padding(18)
              .autocapitalization(.none)
              .disableAutocorrection(true)
              .cardShadow(cornerRadius: 13)
              .padding(.top, 12)

            Button(action: {
              signInUser()
            }) {
              HStack {
                Spacer()

                Text("Save")
                  .foregroundColor(.white)
                  .font(.system(size: 18, weight: .bold))

                Spacer()
              }
            }
            .padding(15)
            .cardShadow(backgroundColor: .purpleColor, cornerRadius: 15)
            .padding(.top, 20)

          }

          Spacer()

        }
        .frame(height: isShowEditProfile ? 280 : 30)
        .padding(.bottom, 20)
        .padding([.top, .horizontal], 30)
        .cardShadow(cornerRadius: 25)
        .padding([.top, .horizontal], 22)

        Spacer()

        if isUserExist {
          Button(action: {
            presenter.signOutUser()
            googleAuthManager.signOut()
          }) {
            HStack {
              Text("Sign Out")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))

              Spacer()

              Image("LogoutIcon")
                .resizable()
                .frame(width: 17, height: 20)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 30)
            .cardShadow(backgroundColor: .red, cornerRadius: 25)
          }
          .padding(.horizontal, 22)
          .padding(.top, 60)
        }

      }
      .onReceive(presenter.$userState) { state in
        if case .success(let user) = state {
          if isUserExist {
            profile = user
            profileImage = user.profilePict
          }
        }
      }

    }
    .progressHUD(isShowing: $presenter.userState.isLoading)
    .navigationTitle("Profile")
    .sheet(isPresented: $isShowMemojiTextView) {
      MemojiView(profileImage: $profileImage, isShowMemojiTextView: $isShowMemojiTextView)
    }
    .fullScreenCover(isPresented: $presenter.signOutState.value ?? false) {
      router.routeSignIn()
    }
    .onTapGesture {
      hideKeyboard()
    }
    .onAppear {
      if isUserExist {
        presenter.fetchUser()
      }
    }
    .onDisappear {
      if isUserExist {
        presenter.stopUser()
      }
    }
    .onReceive(presenter.$createUserState) { state in
      if case .success = state {
        Notifications.dismissSelectRole.post()
      }
    }
  }

  private func signInUser() {
    guard let user = DefaultFirebaseManager.shared.firebaseAuth.currentUser,
          let googleUser = GIDSignIn.sharedInstance.currentUser else { return }

    if !isUserExist {
      let profile: User = .init(
        userId: user.uid,
        role: profile.role,
        name: googleUser.profile?.name ?? profile.name,
        email: googleUser.profile?.email ?? profile.email,
        isParent: profile.role != .children ? true : false,
        profilePict: profileImage
      )

      presenter.createUser(user: profile)

    } else {
      let profile: User = .init(
        userId: user.uid,
        role: profile.role,
        name: googleUser.profile?.name ?? profile.name,
        email: googleUser.profile?.email ?? profile.email,
        isParent: profile.role != .children ? true : false,
        profilePict: profileImage
      )

      presenter.updateUser(user: profile)
      presenter.fetchUser()
      isShowEditProfile.toggle()
    }
  }
}
