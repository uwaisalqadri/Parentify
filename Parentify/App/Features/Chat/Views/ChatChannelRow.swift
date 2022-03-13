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
      VStack(alignment: .leading) {
        Text("Mamah")
          .foregroundColor(.purpleColor)
          .font(.system(size: 18, weight: .semibold))

        Text("Jangan Lupa Kunci Pintu Ya")
          .foregroundColor(Color(.systemGray3))
          .font(.system(size: 15, weight: .medium))
      }

      Spacer()
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 10)
  }
}

struct ChatChannelRow_Previews: PreviewProvider {
  static var previews: some View {
    ChatChannelRow()
      .previewLayout(.fixed(width: 320, height: 100))
  }
}
