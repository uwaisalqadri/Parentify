//
//  HomeView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct HomeView: View {

  @State var profile: User = .initialize
  @State var isShowDetail = false
  @State var isAddWallet = false

  @Namespace var namespace

  let router: HomeRouter
  let assignmentRouter: AssignmentRouter

  var body: some View {
    GeometryReader { geometry in
      NavigationView {
        ScrollView(.vertical, showsIndicators: false) {
          VStack(alignment: .leading) {
            HStack {
              VStack(alignment: .leading) {
                Text("Welcome")
                  .foregroundColor(.gray)
                  .font(.system(size: 17, weight: .regular))

                Text(profile.name)
                  .foregroundColor(.black)
                  .font(.system(size: 18, weight: .bold))
              }

              Spacer()

              NavigationLink(destination: router.routeToProfile()) {
                ImageCard(profileImage: profile.profilePict)
                  .frame(width: 50, height: 50, alignment: .center)
              }

            }.padding([.horizontal, .top], 32)

            MessagesCard(messagesView: router.routeToMessage())
              .frame(height: 243)
              .padding(.top, 20)
              .padding(.horizontal, 25)

            NavigationLink(destination: router.routeToChat()) {
              DetailCard()
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
        .onAppear {
          // TODO: fetch data
        }

      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(router: AppAssembler.shared.resolve(), assignmentRouter: AppAssembler.shared.resolve())
  }
}
