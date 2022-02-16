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
  var isNumberPad = false

  var clickHandler: (() -> Void)? = nil

  private let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter
  }()

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

      if isNumberPad {
        TextField(placeholder, value: $text.int, formatter: numberFormatter, onCommit: {
          hideKeyboard()
        })
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.black)
          .padding(.leading, 10)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .keyboardType(.numberPad)

        HStack {
          Button(action: {
            text.int -= 1
          }) {
            Image(systemName: "minus")
              .foregroundColor(.purpleColor)
          }.frame(width: 8, height: 8)
          .padding(.trailing, 13)

          Button(action: {
            text.int += 1
          }) {
            Image(systemName: "plus")
              .foregroundColor(.purpleColor)
              .frame(width: 10, height: 10)
          }.frame(width: 8, height: 8)

        }.padding(.trailing, 20)

      } else {
        TextField(placeholder, text: $text, onCommit: {
          hideKeyboard()
        })
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.black)
          .padding(.leading, 10)
          .autocapitalization(.none)
          .disableAutocorrection(true)

      }
    }
    .cardShadow(cornerRadius: 13)
  }
}

//struct CommonTextField_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonTextField(placeholder: "Balance")
//      .previewLayout(.sizeThatFits)
//  }
//}
