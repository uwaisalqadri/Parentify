//
//  IconRow.swift
//  Celengan
//
//  Created by Uwais Alqadri on 2/12/22.
//

import SwiftUI

struct IconRow: View {

  let symbol: SFSymbol
  var onSelectSymbol: ((SFSymbol) -> Void)?

  var body: some View {
    Button(action: {
      onSelectSymbol?(symbol)
    }) {
      VStack {
        Image(systemName: symbol.name)
          .foregroundColor(.white)
          .padding()
          .frame(width: 45, height: 45)
          .cardShadow(backgroundColor: .purpleColor, cornerRadius: 12, opacity: 0)

        Text(symbol.name)
          .font(.system(size: 12, weight: .medium))
          .lineLimit(1)
          .truncationMode(.tail)
      }
    }
  }
}

struct IconItemView_Previews: PreviewProvider {
  static var previews: some View {
    IconRow(symbol: SFSymbol(name: "leaf.fill"))
      .previewLayout(.sizeThatFits)
  }
}
