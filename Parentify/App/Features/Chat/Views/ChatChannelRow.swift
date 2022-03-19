//
//  ChatChannelRow.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/13/22.
//

import SwiftUI

enum ChatChannelSection {
  case direct
  case group
}

struct ChatChannelRow: View {

  var section: ChatChannelSection = .direct
  var contact: User = .empty
  var channel: ChatChannel = .empty

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(section == .direct ? contact.name : channel.channelName)
          .foregroundColor(.purpleColor)
          .font(.system(size: 15, weight: .semibold))
      }

      Spacer()
    }
  }
}
