//
//  MessagesCard.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesText: View {

  @State var message: Message = .initialize

  var body: some View {
    Text("\(String(message.role.rawValue)): ")
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(.purpleColor)
    +
    Text(message.message)
      .font(.system(size: 13, weight: .regular))
  }
}

struct MessagesCard: View {

  @State var messages: [Message] = []
  @State var isParent = false
  @State var isShowAll = false

  let router: HomeRouter

  var body: some View {
    NavigationLink(destination: router.routeMessages()) {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          Text("Pesan Penting")
            .font(.system(size: 15, weight: .bold))

          Spacer()

          Dropdown(isExpand: $isShowAll) {
            print("oke")
          }
        }
        .padding(.top, 19)
        .padding(.horizontal, 23)
        .padding(.bottom, 20)

        ForEach(messages, id: \.id) { message in
          HStack {
            MessagesText(message: message)
          }
        }
        .padding(.horizontal, 23)
        .padding(.bottom, isParent ? 0 : 12)

        Spacer()

        if isParent {
          Button(action: {
          }) {
            HStack {
              Spacer()

              Text("Tambahkan Pesan Penting")
                .foregroundColor(.white)
                .font(.system(size: 11, weight: .bold))

              Spacer()
            }
          }
          .padding(15)
          .cardShadow(backgroundColor: .pinkColor, cornerRadius: 15)
          .padding(20)
        }
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
    MessagesCard(router: AppAssembler.shared.resolve())
      .previewLayout(.fixed(width: 300, height: 253))
    //DetailCard().previewLayout(.sizeThatFits)
  }
}

