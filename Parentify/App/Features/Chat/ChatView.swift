//
//  ChatView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI
import Introspect

struct ChatView: View {

  @ObservedObject var presenter: ChatPresenter
  @ObservedObject var membershipPresenter: MembershipPresenter
  @State private var inputText: String = ""
  @State private var chats: [Chat] = []
  @State private var isShowDialog: Bool = false

  let assignment: Assignment
  let section: ChatChannelSection
  let channelName: String
  let currentUser: User
  let sender: User

  init(presenter: ChatPresenter, membershipPresenter: MembershipPresenter, section: ChatChannelSection,  channelName: String, assignment: Assignment, currentUser: User, sender: User) {
    self.currentUser = currentUser
    self.sender = sender
    self.presenter = presenter
    self.membershipPresenter = membershipPresenter
    self.section = section
    self.channelName = channelName
    self.assignment = assignment

    presenter.fetchChats()
  }

  var body: some View {
    VStack {
      ReverseScrollView {
        VStack {
          ForEach(chats, id: \.id) { data in
            ChatRow(chat: data, isSender: data.sender.userId == currentUser.userId) { chat in
              presenter.deleteChat(chat: chat)
            }
          }
        }
        .padding(.top, 25)
      }

      if chats.isEmpty {
        HStack(alignment: .center) {
          Spacer()

          VStack(alignment: .center) {
            Image(systemName: "message.and.waveform.fill")
              .resizable()
              .foregroundColor(.purpleColor)
              .frame(width: 70, height: 60)

            Text("Start a Chat")
              .font(.system(size: 20, weight: .semibold))
              .foregroundColor(.purpleColor)
          }

          Spacer()
        }
        .padding(.vertical, 60)
        .padding(.bottom, 150)
      }

      ChatInputField(text: $inputText) { text in
        presenter.uploadChat(
          chat: .init(sender: currentUser, message: text, sentDate: Date(), isRead: false, channelName: channelName, assignment: assignment, seenBy: [])
        )
      }

    }
    .navigationBarTitle(section == .direct ? sender.name : channelName)
    .navigationBarTitleDisplayMode(.inline)
    .gesture(
      DragGesture(minimumDistance: 20, coordinateSpace: .global)
        .onEnded { value in
          let verticalAmount = value.translation.height as CGFloat

          if verticalAmount > 0 {
            hideKeyboard()
          }
    })
    .overlay(
      VStack {
        switch section {
        case .direct:
          ImageCard(profileImage: sender.profilePict)
            .frame(width: 50, height: 50)
            .padding(.trailing, 20)
            .padding(.top, 45)

        case .group:
          ImageMembersCard(members: [.empty, .empty, .empty])
            .frame(width: 100, height: 100)
            .padding(.trailing, 10)
            .padding(.top, 35)
        }

      }.offset(x: 0, y: -80)
      , alignment: .topTrailing
    )
    .onReceive(presenter.$chatsState) { state in
      if case .success(let data) = state {
        switch section {
        case .direct:
          chats = data.filter { $0.channelName.isEmpty && $0.sender.userId == currentUser.userId || $0.sender.userId == sender.userId }
        case .group:
          chats = data.filter { $0.channelName == channelName }
        }
      }
    }
    .alert(isPresented: $isShowDialog) {
      Alert(
        title: Text("Send Assignment?"),
        message: nil,
        primaryButton: .destructive(Text("No")),
        secondaryButton: .cancel(Text("Yes"), action: { // 1
          isShowDialog.toggle()
          presenter.uploadChat(
            chat: .init(sender: currentUser, message: "assignment_type", sentDate: Date(), isRead: false, channelName: channelName, assignment: assignment, seenBy: [])
          )
        })
      )
    }
    .onAppear {
      isShowDialog = !assignment.id.isEmpty
    }
    .onDisappear {
      presenter.stopChats()
    }

  }
}
