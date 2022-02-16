//
//  ProfileView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ProfileView: View {

  @State private var profile: Profile = .initialize
  @State private var profileImage = UIImage()
  @State private var profileImageData = Data()
  @State private var isShowMemojiTextView = false
  @State private var isShowEditProfile = true
  @State private var isShowDeveloper = false

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          ImageCard(profileImage: profile.profilePict) {
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
            }.padding(15)
              .cardShadow(backgroundColor: .purpleColor, cornerRadius: 15)
              .padding(.top, 20)

          }

          Spacer()

        }
        .frame(height: isShowEditProfile ? 300 : 30)
        .padding(.bottom, 20)
        .padding([.top, .horizontal], 30)
        .cardShadow(cornerRadius: 25)
        .padding([.top, .horizontal], 22)

        Spacer()

        HStack {
          Text("Logout")
            .foregroundColor(.white)
            .font(.system(size: 17, weight: .bold))

          Spacer()

          Image("LogoutIcon")
            .resizable()
            .frame(width: 17, height: 20)
        }.padding(30)
          .cardShadow(backgroundColor: .red, cornerRadius: 25)
          .padding(.horizontal, 22)
          .padding(.top, 60)


      }.onTapGesture {
        hideKeyboard()
      }
    }
    .navigationTitle("Profile")
    .sheet(isPresented: $isShowMemojiTextView) {
      NavigationView {
        MemojiTextView(image: $profileImage)
          .onChange(of: profileImage) { value in
            profile.profilePict = value
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
    .onAppear {
      // TODO: Execute something
    }
    .onDisappear {
      // TODO: Execute something
    }

  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}

