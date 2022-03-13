//
//  MessagesRow.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesRow: View {

  @State var message: Message

  var body: some View {
    HStack {
      MessagesText(message: message)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
    }
    .cardShadow(cornerRadius: 26)
    .padding(.horizontal, 18)
    .padding(.top, 14)
  }
}
