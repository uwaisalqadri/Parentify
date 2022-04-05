//
//  ChatInputField.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatInputField: View {

  @Binding var text: String
  var onSend: (String) -> Void

  var body: some View {
    HStack {
      TextField("Tulis Chat...", text: $text)
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(.black)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .padding(13)
        .background(
          Color.softgrayColor
            .cornerRadius(15)
        )
        .padding(.vertical, 15)
        .padding(.leading, 18)
        .padding(.trailing, 8)

      Button(action: {
        onSend(text)
        text = ""
      }) {
        Image("ArrowUpIcon")
          .resizable()
          .frame(width: 30, height: 30)
          .shadow(radius: 3)
      }.padding(.trailing, 25)
    }
    .cardShadow(cornerRadius: 26)
    .padding([.horizontal, .bottom], 20)
    .onTapGesture {
      hideKeyboard()
    }
  }
}
