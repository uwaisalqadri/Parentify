//
//  ChatChannelRow.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/13/22.
//

import SwiftUI

struct ChatChannelRow: View {

  @State var contact: User = .empty

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(contact.name)
          .foregroundColor(.purpleColor)
          .font(.system(size: 17, weight: .semibold))

        Text("Jangan Lupa Kunci Pintu Ya")
          .foregroundColor(.black)
          .font(.system(size: 12, weight: .regular))
      }

      Spacer()
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 10)
  }
}
