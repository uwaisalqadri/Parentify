//
//  ProfileView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI
import Combine
import Firebase

struct ProfileView: View {

  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var presenter: MembershipPresenter

  @State var isNewUser: Bool
  @State var profile: User

  @State private var profileImage = UIImage()
  @State private var isShowMemojiTextView = false
  @State private var isShowEditProfile = true
  @State private var isShowDeveloper = false

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
            Text(isNewUser ? "Complete Profile" : "Edit Profile")
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
              if isNewUser {
                if let user = Auth.auth().currentUser {
                  presenter.createUser(user: .init(userId: user.uid, role: profile.role, name: profile.name, email: profile.email, password: profile.password, isParent: profile.role != .children ? true : false, profilePict: profileImage))
                }
                presentationMode.wrappedValue.dismiss()
              } else {
                isShowEditProfile.toggle()
              }
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

        if !isNewUser {
          Button(action: {
            presenter.logoutUser()
          }) {
            HStack {
              Text("Logout")
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
      .onAppear {
        if let user = presenter.userState.value, !isNewUser {
          profile = user
          profileImage = user.profilePict
        }
      }
    }
    .progressHUD(isShowing: $presenter.isLoading)
    .navigationTitle("Profile")
    .sheet(isPresented: $isShowMemojiTextView) {
      MemojiView(profileImage: $profileImage, isShowMemojiTextView: $isShowMemojiTextView)
    }
    .onTapGesture {
      hideKeyboard()
    }
    .onAppear {
      if !isNewUser {
        presenter.getUser()
      }
    }
    .onDisappear {
      // TODO: Save changes if any
    }

  }
}
