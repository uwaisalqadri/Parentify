//
//  AddChatChannelView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/19/22.
//

import SwiftUI

struct AddChatChannelView: View {

  let users: [User]
  @State private var members = [User]()
  @State private var chatChannelName: String = ""

  @State private var isSelectUser: Bool = false

  var onAddChatChannel: ((String, [User]) -> Void)?

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
            users: Array(members.prefix(users.count)),
            imageSize: 50,
            onAttachUser: {
              users.forEach {
                members.append($0)
              }
            },
            onDetachUser: { index in
              members.remove(at: index)
            })
        }
        .padding(.horizontal, 30)
      }
      .navigationTitle("Buat Grup")
      .toolbar {
        ToolbarItem(id: "create") {
          Button(action: {
            onAddChatChannel?(chatChannelName, members)
            isSelectUser.toggle()
          }) {
            Text("Buat")
              .foregroundColor(.purpleColor)
          }
        }
      }

    }
  }
}
