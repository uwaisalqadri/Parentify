//
//  ProfileView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ProfileView: View {

  @ObservedObject private var presenter: MembershipPresenter

  @State private var profileImage = UIImage()
  @State private var name: String = ""
  @State private var email: String = ""
  @State private var isShowMemojiTextView = false
  @State private var isShowEditProfile = true
  @State private var isShowDeveloper = false

  init(presenter: MembershipPresenter) {
    self.presenter = presenter
    self.presenter.getUser()
  }

  var body: some View {
    ScrollView {
      if case .success(let profile) = presenter.userState {
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
              Text("Edit Profile")
                .font(.system(size: 17, weight: .bold))

              Spacer()

              Dropdown(isExpand: $isShowEditProfile) {
                withAnimation {
                  isShowEditProfile.toggle()
                }
              }
            }

            if isShowEditProfile {
              TextField("Name", text: $name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(18)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .cardShadow(cornerRadius: 13)
                .padding(.top, 12)

              TextField("Email", text: $email)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(18)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .cardShadow(cornerRadius: 13)
                .padding(.top, 12)

              Button(action: {
                // TODO: Save edited profile
                isShowEditProfile.toggle()
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
        .onAppear {
          if let profile = presenter.userState.value {
            profileImage = profile.profilePict
            name = profile.name
            email = profile.email
          }
        }
      }
    }
    .progressHUD(isShowing: $presenter.isLoading)
    .navigationTitle("Profile")
    .sheet(isPresented: $isShowMemojiTextView) {
      NavigationView {
        MemojiTextView(image: $profileImage)
          .onChange(of: profileImage) { value in
            profileImage = value
            isShowMemojiTextView = false
          }
          .navigationTitle("Memoji")
          .toolbar {
            ToolbarItem(id: "done") {
              Button(action: {
                isShowMemojiTextView = false
              }) {
                Text("Done")
              }
            }
          }
      }
    }
    .onDisappear {
      // TODO: Save changes if any
    }

  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(presenter: AppAssembler.shared.resolve())
  }
}

