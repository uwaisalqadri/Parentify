//
//  DropDown.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct Dropdown: View {

  @Binding var isExpand: Bool
  var onDropdown: (() -> Void)?

  var body: some View {
    Button(action: {
      onDropdown?()
    }) {
      Image(systemName: isExpand ? "chevron.up" : "chevron.down" )
        .resizable()
        .frame(width: 15, height: 7)
    }
  }
}
