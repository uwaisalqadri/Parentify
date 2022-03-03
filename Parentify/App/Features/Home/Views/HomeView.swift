//
//  HomeView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct HomeView: View {

  @ObservedObject var membershipPresenter: MembershipPresenter
  @ObservedObject var presenter: HomePresenter

  @State var isShowDetail = false
  @State var isShowProgress = false
  @State var isShowDialog = false
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
                isParent: isParent,
                router: router,
                onAddMessage: {
                  isShowDialog.toggle()
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

            ForEach(Array(getAssignmentGroups().enumerated()), id: \.offset) { index, item in
              AssignmentGroupItemView(
                isShowDetail: $isShowDetail,
                assignmentGroup: item,
                router: assignmentRouter,
                onDelete: { index in
                  print("delete", index)
                })
            }

          }
        }
        .navigationBarHidden(true)
        .progressHUD(isShowing: $membershipPresenter.userState.isLoading)
        .onAppear {
          membershipPresenter.getUser()
          presenter.getMessages()
        }
        .onReceive(presenter.$addMessageState) { state in
          if case .success = state {
            isShowDialog.toggle()
            presenter.getMessages()
          }
        }
        .onReceive(membershipPresenter.$userState) { state in
          if case .success(let profile) = state {
            isParent = profile.isParent
          }
        }
        .customDialog(isShowing: $isShowDialog) {
          AddMessageDialog(onAddMessage: { textMessage in
            let role = membershipPresenter.userState.value?.role ?? .children
            presenter.addMessage(message: .init(message: textMessage, role: role, datetime: Date()))
          })
        }

      }
    }
  }
}

struct AddMessageDialog: View {

  @State var textMessage: String = ""
  var onAddMessage: (String) -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Text("Pesan Penting")
        .font(.system(size: 16, weight: .bold))

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
  static var previews: some View {
    HomeView(membershipPresenter: AppAssembler.shared.resolve(), presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve(), assignmentRouter: AppAssembler.shared.resolve())
  }
}
