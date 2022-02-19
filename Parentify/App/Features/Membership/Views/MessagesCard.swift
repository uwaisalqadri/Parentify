//
//  MessagesCard.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesText: View {

  @State var sender: String = ""
  @State var message: String = ""

  var body: some View {
    Text("\(sender): ")
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(.purpleColor)
    +
    Text(message)
      .font(.system(size: 13, weight: .regular))
  }
}

struct MessagesCard: View {

  @State var isShowAll = false
  let messagesView: MessagesView

  var body: some View {
    NavigationLink(destination: messagesView) {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          Text("Pesan Penting")
            .font(.system(size: 15, weight: .bold))

          Spacer()

          Dropdown(isExpand: $isShowAll) {
            print("oke")
          }
        }.padding(.top, 19)
          .padding(.horizontal, 23)

        ForEach(0..<3) { _ in
          HStack {
            MessagesText(
              sender: "Mamak",
              message: "Jangan lupa ngerjain PR ya bil, udah ditagih sama bu guru Fatimah"
            )

          }.padding(.top, 10)

        }.padding(.horizontal, 23)

        Spacer()
      }
    }.buttonStyle(FlatLinkStyle())
    .cardShadow(cornerRadius: 23)
  }
}

struct OpenChatCard: View {

  var body: some View {
    HStack {
      Text("Chat")
        .foregroundColor(.black)
        .font(.system(size: 16, weight: .bold))
        .padding(.leading, 31)

      Spacer()

      ZStack(alignment: .topTrailing) {
        Image("ArrowIcon")
          .resizable()
          .frame(width: 26, height: 26, alignment: .center)
          .shadow(radius: 3)
          .padding(.trailing, 35)

        Text("2")
          .foregroundColor(.white)
          .font(.system(size: 12, weight: .bold))
          .padding(.horizontal, 5)
          .padding(.vertical, 3)
          .background(Color.redColor)
          .clipShape(Capsule())
          .padding(.top, -10)
          .padding(.trailing, 27)
      }
      .frame(width: 28, height: 28, alignment: .center)
    }
    .padding(.vertical, 21)
    .cardShadow(cornerRadius: 23)
  }
}

struct DashboardCard_Previews: PreviewProvider {

  static var previews: some View {
    let router = MembershipRouter(assembler: AppAssembler.shared)
    MessagesCard(messagesView: router.routeMessages())
      .previewLayout(.fixed(width: 300, height: 253))
    //DetailCard().previewLayout(.sizeThatFits)
  }
}

