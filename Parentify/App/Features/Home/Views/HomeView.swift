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
  @ObservedObject var presenter: HomePresenter

  @State var assignmentGroups = [AssignmentGroup]()
  @State var assignments = [Assignment]()

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

            if case .success(let messages) = presenter.messagesState {
              MessagesCard(
                messages: messages,
                isParent: $isParent,
                router: router,
                onAddMessage: {
                  isAddMessage.toggle()
                }
              )
                .frame(height: 243)
                .padding(.top, 20)
                .padding(.horizontal, 25)
            }

            NavigationLink(destination: router.routeChat()) {
              OpenChatCard()
                .padding(.top, 28)
                .padding(.horizontal, 25)
            }

            ForEach(
              Array(assignmentGroups.enumerated()),
              id: \.offset
            ) { index, item in
              AssignmentGroupItemView(
                isShowDetail: $isShowDetail,
                isParent: $isParent,
                assignmentGroup: item,
                router: assignmentRouter,
                onDelete: { assignment in
                  assignmentPresenter.deleteAssignment(assignment: assignment)
                },
                onUploaded: {
                  assignmentPresenter.getAssignments()
                }
              )
            }

          }
        }
        .navigationBarHidden(true)
        .progressHUD(isShowing: $membershipPresenter.userState.isLoading)
        .onAppear {
          membershipPresenter.getUser()
          presenter.getMessages()
          assignmentPresenter.getAssignments()
        }
        .onReceive(presenter.$addMessageState) { state in
          if case .success = state {
            isAddMessage.toggle()
            presenter.getMessages()
          }
        }
        .onReceive(membershipPresenter.$userState) { state in
          if case .success(let profile) = state {
            isParent = profile.isParent
          }
        }
        .onReceive(assignmentPresenter.$assignmentsState) { state in
          if case .success(let data) = state {
            assignmentGroups = getAssignmentGroups(assignments: data)
          }
        }
        .customDialog(isShowing: $isAddMessage) {
          AddMessageDialog { textMessage in
            let role = membershipPresenter.userState.value?.role ?? .children
            presenter.addMessage(message: .init(message: textMessage, role: role, datetime: Date()))
          } onDismiss: {
            isAddMessage.toggle()
          }
        }

      }
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

    }.padding(20)
    .cardShadow(cornerRadius: 24)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var assembler: Assembler = AppAssembler()

  static var previews: some View {
    HomeView(membershipPresenter: assembler.resolve(), assignmentPresenter: assembler.resolve(), presenter: assembler.resolve(), router: assembler.resolve(), assignmentRouter: assembler.resolve())
  }
}
