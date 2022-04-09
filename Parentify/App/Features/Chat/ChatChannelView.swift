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

  @State var currentUser: User = .empty
  @State var contacts = [User]()
  @State var channels = [ChatChannel]()
  @State var users = [User]()
  @State var isAddChatChannel: Bool = false

  let assignment: Assignment
  let router: ChatRouter

  init(presenter: ChatPresenter, membershipPresenter: MembershipPresenter, assignment: Assignment = .empty, router: ChatRouter) {
    self.router = router
    self.presenter = presenter
    self.membershipPresenter = membershipPresenter
    self.assignment = assignment
  }

  var body: some View {
    ZStack {
      if !presenter.channelsState.isLoading {
        List {
          Section(header: Text("Direct")) {
            ForEach(contacts, id: \.userId) { user in
              NavigationLink(
                destination: router.routeChat(currentUser: currentUser, sender: user, assignment: assignment, channel: .empty, section: .direct)
              ) {
                ChatChannelRow(section: .direct, contact: user)
              }.buttonStyle(PlainButtonStyle())
            }
          }

          Section(header: Text("Group")) {
            HStack {
              Text("Buat Grup")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.purpleColor)

              Spacer()

              Button(action: {
                isAddChatChannel.toggle()
              }) {
                Image(systemName: "plus")
                  .foregroundColor(.purpleColor)
              }
            }

            ForEach(channels, id: \.id) { channel in
              NavigationLink(
                destination: router.routeChat(currentUser: currentUser, sender: .empty, assignment: assignment, channel: channel, section: .group)
              ) {
                ChatChannelRow(section: .group, channel: channel)
              }.buttonStyle(PlainButtonStyle())
            }
          }
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarTitleDisplayMode(.large)
    .navigationBarTitle("Chats")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        VStack {
          Button(action : {
            presentationMode.wrappedValue.dismiss()
          }) {
            HStack {
              Image(systemName: "chevron.left")
              Text("Back").padding(.trailing, -5)
            }.foregroundColor(.accentColor)
          }
        }

      }
    }
    .progressHUD(isShowing: $presenter.addChatChannelState.isLoading)
    .showSheet(isPresented: $isAddChatChannel) {
      AddChatChannelView(users: users) { name, members in
        presenter.addChatChannel(channel: .init(channelName: name, users: members))
        presenter.fetchChannels()
      }
    }
    .onAppear {
      membershipPresenter.fetchUsers()
      membershipPresenter.fetchUser()

      DispatchQueue.main.async {
        presenter.fetchChannels()
      }
    }
    .onReceive(presenter.$addChatChannelState) { state in
      if case .success = state {
        isAddChatChannel = false
      }
    }
    .onReceive(membershipPresenter.$userState) { state in
      if case .success(let data) = state {
        currentUser = data
      }
    }
    .onReceive(membershipPresenter.$allUserState) { state in
      if case .success(let data) = state {
        contacts = data.filter { $0.userId != currentUser.userId }
        users = data
      }
    }
    .onReceive(presenter.$channelsState) { state in
      if case .success(let data) = state {
        channels = data
          //.filter { $0.users.contains(currentUser) }
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
