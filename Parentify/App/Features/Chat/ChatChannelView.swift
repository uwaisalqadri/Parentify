//
//  ChatChannelView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/13/22.
//

import SwiftUI

struct ChatChannelView: View {

  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var presenter: ChatPresenter
  @ObservedObject var membershipPresenter: MembershipPresenter

  @State var assignment: Assignment = .empty
  @State var sender: User = .empty
  @State var contacts: [User] = []

  let router: ChatRouter

  var body: some View {
    List {
      Section(header: Text("Direct")) {
        ForEach(contacts, id: \.userId) { user in
          NavigationLink(destination: router.routeChat(sender: sender, assignment: assignment)) {
            ChatChannelRow(contact: user)
          }.buttonStyle(PlainButtonStyle())
        }
      }
    }
    .navigationTitle("Chats")
    .onAppear {
      membershipPresenter.fetchUsers()
      membershipPresenter.fetchUser()
    }
    .onDisappear(perform: {
      membershipPresenter.stopUsers()
    })
    .onReceive(membershipPresenter.$userState) { state in
      if case .success(let data) = state {
        sender = data
      }
    }
    .onReceive(membershipPresenter.$allUserState) { state in
      if case .success(let data) = state {
        contacts = data.filter { $0.userId != sender.userId }
      }
    }
  }
}

struct ChatChannelView_Previews: PreviewProvider {

  static var assembler: Assembler = AppAssembler()

  static var previews: some View {
    ChatChannelView(presenter: assembler.resolve(), membershipPresenter: assembler.resolve(), router: assembler.resolve())
  }
}
