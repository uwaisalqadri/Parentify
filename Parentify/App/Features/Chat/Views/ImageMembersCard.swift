//
//  ImageMembersCard.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/18/22.
//

import SwiftUI

struct ImageMembersCard: View {

  var members: [User]

  var body: some View {

    if members.count == 1 {
      ImageCard(profileImage: members[0].profilePict)
        .frame(width: 38, height: 38)

    } else if members.count == 2 {
      HStack {
        ImageCard(profileImage: members[0].profilePict).frame(width: 38, height: 38)
        ImageCard(profileImage: members[1].profilePict).frame(width: 38, height: 38)
      }

    } else if members.count == 3 {
      VStack {
        HStack {
          ImageCard(profileImage: members[0].profilePict)
            .frame(width: 38, height: 38)

          ImageCard(profileImage: members[1].profilePict)
            .frame(width: 38, height: 38)
        }

        HStack {
          ImageCard(profileImage: members[2].profilePict)
            .frame(width: 38, height: 38)
        }
      }
    } else if members.count == 4 {
      VStack {
        HStack {
          ImageCard(profileImage: members[0].profilePict)
            .frame(width: 38, height: 38)

          ImageCard(profileImage: members[1].profilePict)
            .frame(width: 38, height: 38)
        }

        HStack {
          ImageCard(profileImage: members[2].profilePict)
            .frame(width: 38, height: 38)

          ImageCard(profileImage: members[3].profilePict)
            .frame(width: 38, height: 38)
        }
      }
    }

  }
}

struct ImageMembersCard_Previews: PreviewProvider {

  static var fourUsers: [User] = [
    .empty,
    .empty,
    .empty,
    .empty
  ]

  static var previews: some View {
    ImageMembersCard(members: fourUsers)
      .previewLayout(.fixed(width: 100, height: 100))
  }
}
