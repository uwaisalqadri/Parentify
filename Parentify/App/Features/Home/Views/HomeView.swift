//
//  HomeView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct HomeView: View {

  @ObservedObject var membershipPresenter: MembershipPresenter
  @ObservedObject var assignmentPresenter: AssignmentPresenter
  @ObservedObject var chatPresenter: ChatPresenter
  @ObservedObject var presenter: HomePresenter

  @State var assignmentGroups = [AssignmentGroup]()
  @State var assignments = [Assignment]()
  @State var messages = [Message]()

  @State var currentUser: User = .empty
  @State var selectedAssignmentId: String = ""
  @State var unreadChats: Int = 0
  @State var isShowDetail = false
  @State var isShowProgress = false
  @State var isAddMessage = false
  @State var isParent = false

  let router: HomeRouter
  let assignmentRouter: AssignmentRouter

  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        ScrollView(.vertical, showsIndicators: false) {
          VStack(alignment: .leading) {
            HStack {
              VStack(alignment: .leading) {
                Text("Welcome")
                  .foregroundColor(.gray)
                  .font(.system(size: 17, weight: .regular))

                Text(membershipPresenter.userState.value?.name ?? "")
                  .foregroundColor(.black)
                  .font(.system(size: 18, weight: .bold))
              }

              Spacer()

              NavigationLink(destination: router.routeProfile()) {
                ImageCard(profileImage: membershipPresenter.userState.value?.profilePict ?? UIImage())
                  .frame(width: 50, height: 50, alignment: .center)
              }

            }.padding([.horizontal, .top], 32)

            MessagesCard(
              messages: $messages,
              isParent: $isParent,
              router: router,
              onAddMessage: {
                isAddMessage.toggle()
              }
            )
            .frame(height: 243)
            .padding(.top, 20)
            .padding(.horizontal, 25)

            NavigationLink(destination: router.routeChatChannel()) {
              OpenChatCard(unreadChats: $unreadChats)
                .padding(.top, 28)
                .padding(.horizontal, 25)
            }

            ForEach(
              Array(assignmentGroups.enumerated()),
              id: \.offset
            ) { index, item in

              AssignmentGroupRow(
                router: assignmentRouter,
                selectedAssignmentId: selectedAssignmentId,
                isShowDetail: $isShowDetail,
                isParent: $isParent,
                assignmentGroup: item,
                onSwipe: { action in
                  switch action {
                  case .finished(let assignment):
                    assignmentPresenter.updateFinishedAssignment(assignment: assignment)
                  case .none:
                    break
                  }
                },
                onDelete: { assignment in
                  assignmentPresenter.deleteAssignment(assignment: assignment)
                },
                onShowDetail: { assignmentId in
                  selectedAssignmentId = assignmentId
                  isShowDetail.toggle()
                },
                onUploaded: {
                  assignmentPresenter.fetchAssignments()
                }
              )
            }

          }
        }
        .navigationBarHidden(true)
        .progressHUD(isShowing: $membershipPresenter.userState.isLoading)
        .onAppear {
          presenter.fetchMessages()
          assignmentPresenter.fetchAssignments()
          chatPresenter.fetchUnreadChats()
        }
        .onReceive(presenter.$addMessageState) { state in
          if case .success = state {
            isAddMessage.toggle()
            presenter.fetchMessages()
          }
        }
        .onReceive(membershipPresenter.$userState) { state in
          if case .success(let profile) = state {
            isParent = profile.isParent
            currentUser = profile
          }
        }
        .onReceive(assignmentPresenter.$assignmentsState) { state in
          if case .success(let data) = state {
            let filteredData = data.filterAssignedAssignments(currentUser: currentUser)
            assignmentGroups = getAssignmentGroups(assignments: isParent ? data : filteredData)
          }
        }
        .onReceive(assignmentPresenter.$deleteAssignmentState) { state in
          if case .success = state {
            assignmentPresenter.fetchAssignments()
          }
        }
        .onReceive(chatPresenter.$unreadChatsState) { state in
          if case .success(let data) = state {
            unreadChats = data
          }
        }
        .onReceive(presenter.$messagesState) { state in
          if case .success(let data) = state {
            messages = data
          }
        }
        .customDialog(isShowing: $isAddMessage) {
          AddMessageDialog { textMessage in
            let role = membershipPresenter.userState.value?.role ?? .children
            presenter.addMessage(message: .init(message: textMessage, role: role, sentDate: Date()))
          } onDismiss: {
            isAddMessage.toggle()
          }
        }

      }
    }
    .onAppear {
      assignmentGroups = getAssignmentGroups(assignments: [])
      membershipPresenter.fetchUser()
    }
    .onDisappear {
      membershipPresenter.stopUser()
    }
  }
}

struct AddMessageDialog: View {

  @State var textMessage: String = ""
  var onAddMessage: (String) -> Void
  var onDismiss: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Pesan Penting")
          .font(.system(size: 16, weight: .bold))

        Spacer()

        Button(action: {
          onDismiss()
        }) {
          Image(systemName: "xmark")
            .resizable()
            .foregroundColor(.black)
            .frame(width: 13, height: 13, alignment: .center)
        }
      }

      TextEditor(text: $textMessage)
        .font(.system(size: 14, weight: .regular))
        .frame(height: 200)
        .autocapitalization(.none)
        .disableAutocorrection(true)

      Button(action: {
        onAddMessage(textMessage)
      }) {
        HStack {
          Spacer()

          Text("Tambahkan Pesan Penting")
            .foregroundColor(.white)
            .font(.system(size: 13, weight: .bold))

          Spacer()
        }
      }
      .padding(15)
      .cardShadow(backgroundColor: .pinkColor, cornerRadius: 15)

    }
    .padding(20)
    .cardShadow(cornerRadius: 24)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var assembler: Assembler = AppAssembler()

  static var previews: some View {
    HomeView(membershipPresenter: assembler.resolve(), assignmentPresenter: assembler.resolve(), chatPresenter: assembler.resolve(), presenter: assembler.resolve(), router: assembler.resolve(), assignmentRouter: assembler.resolve())
  }
}
