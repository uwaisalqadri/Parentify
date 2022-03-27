//
//  CommonTextField.swift
//  Celengan
//
//  Created by Uwais Alqadri on 1/21/22.
//

import SwiftUI

struct CommonTextField: View {

  var placeholder: String = ""
  @Binding var text: String
  var image: UIImage?
  var keyboardType: UIKeyboardType = .default
  var isPassword: Bool = false

  var clickHandler: (() -> Void)? = nil

  var body: some View {
    HStack {
      Button(action: {
        clickHandler?()
      }) {
        Image(uiImage: image!)
          .scaleEffect(1)
          .foregroundColor(.black)
          .padding()
          .padding(.horizontal, 5)
          .overlay(
            RoundedRectangle(cornerRadius: 0)
              .stroke(Color.gray.opacity(0.3), lineWidth: 1)
              .cornerRadius(13, corners: [.bottomLeft, .topLeft])
          )
      }

      if isPassword {
        SecureTextField(title: placeholder, text: $text)
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.black)
        .padding(.leading, 10)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(keyboardType)

      } else {
        TextField(placeholder, text: $text, onCommit: {
          hideKeyboard()
        })
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.black)
        .padding(.leading, 10)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(keyboardType)
      }

    }
    .cardShadow(cornerRadius: 13)
  }
}

struct SecureTextField: View {

  var title: String
  @Binding var text: String
  @State var isSecured: Bool = true

  var body: some View {
    ZStack(alignment: .trailing) {
      if isSecured {
        SecureField(title, text: $text)
      } else {
        TextField(title, text: $text)
      }

      Button(action: {
        isSecured.toggle()
      }) {
        Image(systemName: self.isSecured ? "eye.slash" : "eye")
          .accentColor(.gray)
      }.padding(.trailing, 15)

    }
  }
}
