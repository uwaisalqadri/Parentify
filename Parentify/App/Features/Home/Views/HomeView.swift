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
              messages: presenter.messagesState.value ?? [],
              isParent: membershipPresenter.userState.value?.isParent ?? false,
              router: router
            )
            .frame(height: 243)
            .padding(.top, 20)
            .padding(.horizontal, 25)

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
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(membershipPresenter: AppAssembler.shared.resolve(), presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve(), assignmentRouter: AppAssembler.shared.resolve())
  }
}
