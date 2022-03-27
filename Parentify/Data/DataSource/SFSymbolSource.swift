//
//  SFSymbolSource.swift
//  Celengan
//
//  Created by Uwais Alqadri on 2/12/22.
//

import SwiftUI

enum SortOrder: String, CaseIterable {
  case defaultOrder = "Sorted by Default"
  case name = "Sorted by Name"
}

class SFSymbolSource {
  private var symbolsSortedByDefault = [SFSymbol]()
  private var symbolsSortedByName = [SFSymbol]()
  private var multicolorSymbols = [SFSymbol]()

  init() {
    loadSymbols()
  }

  func symbols(for sortOrder: SortOrder, filter: String = "") -> [SFSymbol] {
    let symbolsMap: [SortOrder: [SFSymbol]] = [.defaultOrder: symbolsSortedByDefault,
                                               .name: symbolsSortedByName]
    let symbols = symbolsMap[sortOrder] ?? []
    if filter.isEmpty {
      return symbols
    }

    return symbols.filter { $0.name.lowercased().contains(filter.lowercased()) }
  }
}

extension SFSymbolSource {
  private func loadSymbols() {
    let defaultOrderStrings = symbolsFromFile(name: "SymbolsSortedByDefault")
    let nameStrings = symbolsFromFile(name: "SymbolsSortedByName")

    symbolsSortedByDefault = defaultOrderStrings.map {
      SFSymbol(name: $0)
    }
    symbolsSortedByName = nameStrings.map {
      SFSymbol(name: $0)
    }
  }

  private func symbolsFromFile(name: String) -> [String] {
    guard let fileURL = Bundle.main.url(forResource: name, withExtension: "txt"),
          let fileContents = try? String(contentsOf: fileURL) else {
            return []
          }
    return fileContents.split(separator: "\n").compactMap { $0.isEmpty ? nil : String($0) }
  }
}
