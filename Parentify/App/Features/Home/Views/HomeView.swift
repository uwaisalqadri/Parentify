//
//  HomeView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct HomeView: View {

  @ObservedObject var presenter: MembershipPresenter
  @State var isShowDetail = false
  @State var isShowProgress = false

  let router: HomeRouter
  let assignmentRouter: AssignmentRouter

  init(presenter: MembershipPresenter, router: HomeRouter, assignmentRouter: AssignmentRouter) {
    self.presenter = presenter
    self.router = router
    self.assignmentRouter = assignmentRouter
    self.presenter.getUser()
  }

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          HStack {
            VStack(alignment: .leading) {
              Text("Welcome")
                .foregroundColor(.gray)
                .font(.system(size: 17, weight: .regular))

              Text(presenter.userState.value?.name ?? "")
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .bold))
            }

            Spacer()

            NavigationLink(destination: router.routeToProfile()) {
              ImageCard(profileImage: presenter.userState.value?.profilePict ?? UIImage())
                .frame(width: 50, height: 50, alignment: .center)
            }

          }.padding([.horizontal, .top], 32)

          MessagesCard(messagesView: router.routeToMessage())
            .frame(height: 243)
            .padding(.top, 20)
            .padding(.horizontal, 25)

          NavigationLink(destination: router.routeToChat()) {
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
      .progressHUD(isShowing: $presenter.isLoading)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(presenter: AppAssembler.shared.resolve(), router: AppAssembler.shared.resolve(), assignmentRouter: AppAssembler.shared.resolve())
  }
}
