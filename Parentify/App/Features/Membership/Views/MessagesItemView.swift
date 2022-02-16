//
//  MessagesItemView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesItemView: View {
  var body: some View {
    HStack {
      MessagesText(
        sender: "Mamak",
        message: "Jangan lupa ngerjain PR ya bil, udah ditagih sama bu guru Fatimah"
      )
      .padding(25)
    }
    .cardShadow(cornerRadius: 26)
    .padding(.horizontal, 18)
    .padding(.top, 14)
  }
}

struct MessagesItemView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesItemView()
  }
}
