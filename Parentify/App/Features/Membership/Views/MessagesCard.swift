//
//  MessagesCard.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesText: View {

  @State var message: Message = .empty

  var roleName: String {
    switch message.role {
    case .father:
      return "Ayah"
    case .mother:
      return "Ibu"
    case .children:
      return "unknown"
    }
  }

  var body: some View {
    Text("\(roleName): ")
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(.purpleColor)
    +
    Text(message.message)
      .font(.system(size: 13, weight: .regular))
  }
}

struct MessagesCard: View {

  @Binding var messages: [Message]
  @Binding var isParent: Bool

  let router: HomeRouter

  var onAddMessage: () -> Void

  var body: some View {
    VStack {
      HStack(alignment: .center) {
        Text("Pesan Penting")
          .font(.system(size: 15, weight: .bold))

        Spacer()
      }
      .padding(.top, 19)
      .padding(.bottom, 10)
      .padding(.horizontal, 23)

      NavigationLink(destination: router.routeMessages(isParent: $isParent)) {
        VStack(alignment: .leading) {
          ForEach(Array(messages.prefix(5)), id: \.id) { message in
            HStack {
              MessagesText(message: message)

              Spacer()
            }
          }
          .padding(.horizontal, 23)
          .padding(.bottom, 3)

          if messages.isEmpty {
            Image(systemName: "bell.slash.fill")
              .resizable()
              .foregroundColor(.purpleColor)
              .frame(width: 30, height: 30)
              .padding(.top, 50)
          }
        }
      }
      .buttonStyle(FlatLinkStyle())

      Spacer()

      if isParent {
        Button(action: {
          onAddMessage()
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
        .padding(20)
      }

    }
    .cardShadow(cornerRadius: 23)
  }
}

struct OpenChatCard: View {

  @Binding var unreadChats: Int

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

        Text("\(unreadChats)")
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
