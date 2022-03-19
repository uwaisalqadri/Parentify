//
//  AddChatChannelView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/19/22.
//

import SwiftUI

struct AddChatChannelView: View {

  @State private var chatChannelName: String = ""

  var onAddChatChannel: ((String) -> Void)?

  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          TextField("Nama Grup", text: $chatChannelName)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black)
            .padding(18)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .cardShadow(cornerRadius: 13)
            .padding(.top, 12)
        }
        .padding(20)
      }
      .navigationTitle("Buat Grup")
      .toolbar {
        ToolbarItem(id: "create") {
          Button(action: {
            onAddChatChannel?(chatChannelName)
          }) {
            Text("Buat")
              .foregroundColor(.purpleColor)
          }
        }
      }

    }
  }
}
