//
//  MessagesView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesView: View {
  var body: some View {
    ScrollView {
      ForEach(0..<10) { _ in
        MessagesItemView()
      }
    }
    .navigationBarTitle("Pesan Penting")
  }
}

struct MessagesView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesView()
  }
}
