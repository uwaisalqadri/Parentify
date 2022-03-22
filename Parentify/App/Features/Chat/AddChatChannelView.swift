//
//  AddChatChannelView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/19/22.
//

import SwiftUI

struct AddChatChannelView: View {

  @State private var chatChannelName: String = ""
  @State private var members: [User] = []
  @State private var isSelectUser: Bool = false

  var onAddChatChannel: ((String) -> Void)?

  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          TextField("Nama Grup", text: $chatChannelName)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.black)
            .padding(15)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .cardShadow(cornerRadius: 13)
            .padding(.top, 12)

          AttachUserView(
            users: members,
            imageSize: 50,
            onSelectUser: {_ in

            },
            onAttachUser: {
              isSelectUser.toggle()
            },
            onDetachUser: {index in
              members.remove(at: index)
            })
        }
        .padding(.horizontal, 30)
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
