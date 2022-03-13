//
//  ChatChannelRow.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/13/22.
//

import SwiftUI

struct ChatChannelRow: View {
  var body: some View {
    HStack {
      VStack {
        Text("Mamah")
          .font(.system(size: 20, weight: .semibold))

        Text("Jangan Lupa Kunci Pintu Ya")
          .font(.system(size: 15, weight: .medium))
      }

      Spacer()
    }
  }
}

struct ChatChannelRow_Previews: PreviewProvider {
  static var previews: some View {
    ChatChannelRow()
      .previewLayout(.fixed(width: 320, height: 100))
  }
}
