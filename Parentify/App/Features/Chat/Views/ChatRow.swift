//
//  ChatRow.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct ChatRow: View {

  @State var chat: Chat = .initialize
  @State var isSender: Bool = false

  var onDelete: ((Chat) -> Void)?

  var body: some View {
    HStack {
      if isSender {
        Spacer()
      }

      Text(chat.message)
        .foregroundColor(.white)
        .font(.system(size: 13, weight: .medium))
        .padding(.horizontal, 19)
        .padding(.vertical, 11)
        .cardShadow(backgroundColor: isSender ? Color.pinkColor : Color.purpleColor, cornerRadius: 22, opacity: 0, radius: 0)
        .contextMenu {
//          Button(action: {
//          }) {
//            Label("Detail", systemImage: "info.circle.fill")
//          }

          if isSender {
            if #available(iOS 15.0, *) {
              Button(role: .destructive) {
                onDelete?(chat)
              } label: {
                Label("Remove", systemImage: "trash.fill")
              }
            } else {
              Button(action: {
                onDelete?(chat)
              }) {
                Label("Remove", systemImage: "trash.fill")
              }
            }
          }

        }
        .padding(.horizontal, 19)
        .padding(.bottom, 15)

      if !isSender {
        Spacer()
      }
    }

  }
}
