//
//  HomeView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct HomeView: View {

  @AppStorage(Constant.isUserExist) var isUserExist: Bool = false
  @EnvironmentObject var googleAuthManager: GoogleAuthManager
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
  @State var isSignedOut = false

  let router: HomeRouter
  let assignmentRouter: AssignmentRouter

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          HStack {
            VStack(alignment: .leading) {
              Text("Welcome")
                .foregroundColor(.gray)
                .font(.system(size: 17, weight: .regular))

              Text(currentUser.name)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .bold))
            }

            Spacer()

            NavigationLink(destination: router.routeProfile()) {
              ImageCard(profileImage: currentUser.profilePict)
                .frame(width: 50, height: 50, alignment: .center)
            }

          }.padding([.horizontal, .top], 32)

          MessagesCard(
            messages: $messages,
            isParent: currentUser.isParent,
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
              isParent: currentUser.isParent,
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
        membershipPresenter.fetchUsers()
      }
      .onViewStatable(
        presenter.$addMessageState,
        onSuccess: { _ in
          isAddMessage.toggle()
          presenter.fetchMessages()
        }
      )
      .onViewStatable(
        membershipPresenter.$userState,
        onSuccess: { profile in
          currentUser = profile
        }
      )
      .onViewStatable(
        membershipPresenter.$allUserState,
        onSuccess: { data in
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            isUserExist = data.filter { $0.userId == currentUser.userId }.count > 0
          }
        },
        onError: { _ in
          isUserExist = false
        }
      )
      .onViewStatable(
        assignmentPresenter.$assignmentsState,
        onSuccess: { data in
          let filteredData = data.filterAssignedAssignments(currentUser: currentUser)
          assignmentGroups = getAssignmentGroups(assignments: currentUser.isParent ? data : filteredData)
        }
      )
      .onViewStatable(
        assignmentPresenter.$deleteAssignmentState,
        onSuccess: { _ in
          assignmentPresenter.fetchAssignments()
        }
      )
      .onViewStatable(
        chatPresenter.$unreadChatsState,
        onSuccess: { data in
          unreadChats = data
        }
      )
      .onViewStatable(
        presenter.$messagesState,
        onSuccess: { data in
          messages = data
        }
      )
      .fullScreenCover(isPresented: $isSignedOut) {
        router.routeSignIn()
      }
      .customDialog(isShowing: $isAddMessage) {
        AddMessageDialog { textMessage in
          let role = currentUser.role
          presenter.addMessage(message: .init(message: textMessage, role: role, sentDate: Date()))
        } onDismiss: {
          isAddMessage.toggle()
        }
      }
    }
    .navigationViewStyle(.stack)
    .onAppear {
      assignmentGroups = getAssignmentGroups(assignments: [])
      membershipPresenter.fetchUser()

      if isUserExist {
        membershipPresenter.fetchUsers()
      }

      isSignedOut = DefaultFirebaseManager.shared.firebaseAuth.currentUser == nil
    }
    .onDisappear {
      assignmentPresenter.stopAssignments()
    }
  }

  private func signOut() {
    membershipPresenter.signOutUser()
    googleAuthManager.signOut()
    isSignedOut = true
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
