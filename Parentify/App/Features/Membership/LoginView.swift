//
//  LoginView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct LoginView: View {

  @State var email: String = ""
  @State var password: String = ""

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {

        ImageCard(profileImage: UIImage(systemName: "envelope.fill")!)
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
          // TODO: Save edited profile
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
          // TODO: Save edited profile
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
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}