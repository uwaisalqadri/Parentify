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
  @State private var isSignedOut = false
  @State private var isConfirmSignOut = false

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
            Text(isUserExist ? "Edit Profile" : "Complete Profile")
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
            isConfirmSignOut.toggle()
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
    .progressHUD(isShowing: $presenter.updateUserState.isLoading)
    .navigationTitle("Profile")
    .alert(isPresented: $isConfirmSignOut) {
      Alert(
        title: Text("Confirm Sign Out?"),
        primaryButton: .default(Text("No"), action: {
          isConfirmSignOut.toggle()
        }),
        secondaryButton: .destructive(Text("Yes"), action: {
          isConfirmSignOut.toggle()
          signOut()
        })
      )
    }
    .sheet(isPresented: $isShowMemojiTextView) {
      MemojiView(profileImage: $profileImage, isShowMemojiTextView: $isShowMemojiTextView)
    }
    .fullScreenCover(isPresented: $isSignedOut) {
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
    .onReceive(presenter.$updateUserState) { state in
      if case .success = state {
        isShowEditProfile.toggle()
      }
    }
  }

  private func signOut() {
    presenter.signOutUser()
    googleAuthManager.signOut()
    isSignedOut = true
  }

  private func signInUser() {
    let profile: User = .init(
      userId: DefaultFirebaseManager.shared.firebaseAuth.currentUser?.uid ?? "",
      role: profile.role,
      name: GIDSignIn.sharedInstance.currentUser?.profile?.name ?? profile.name,
      email: GIDSignIn.sharedInstance.currentUser?.profile?.email ?? profile.email,
      isParent: profile.role != .children ? true : false,
      profilePict: profileImage
    )

    if !isUserExist {
      presenter.createUser(user: profile)
    } else {
      presenter.updateUser(user: profile)
    }
  }
}
