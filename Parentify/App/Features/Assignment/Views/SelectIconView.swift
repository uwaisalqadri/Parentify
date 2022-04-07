//
//  SelectIconView.swift
//  Celengan
//
//  Created by Uwais Alqadri on 2/11/22.
//

import SwiftUI

struct SelectIconView: View {

  let sfSymbols: SFSymbolSource
  @State private var sortOrder: SortOrder = .defaultOrder

  var onSelectSymbol: ((SFSymbol) -> Void)?

  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading) {

          Text("Select Category")
            .font(.system(size: 15, weight: .bold))
            .padding(.bottom, 20)
            .padding(.top, 0)
            .frame(alignment: .leading)

          LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 40), spacing: 40, alignment: .center)
          ], alignment: .center, spacing: 25) {
            ForEach(sfSymbols.symbols(for: sortOrder), id: \.self) { symbol in
              IconRow(symbol: symbol, onSelectSymbol: onSelectSymbol)
            }
          }
        }.padding(20)
        .padding(.horizontal, 20)
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Menu {
            Picker(selection: $sortOrder, label: Text("Sort")) {
              ForEach(SortOrder.allCases, id: \.self) { order in
                Text(order.rawValue).tag(order)
              }
            }
          } label: {
            Image(systemName: "ellipsis.circle.fill")
          }
        }
      }
    }
    .navigationViewStyle(.stack)
  }
}

struct SelectIconView_Previews: PreviewProvider {
  static var previews: some View {
    SelectIconView(sfSymbols: AppAssembler.shared.resolve())
  }
}
