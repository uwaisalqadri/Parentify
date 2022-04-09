//
//  ChatAssignmentRow.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/17/22.
//

import SwiftUI

struct ChatAssignmentRow: View {

  let assignment: Assignment

  var body: some View {
    HStack {
      VStack(alignment: .trailing) {
        Text(assignment.title)
          .font(.system(size: 12, weight: .semibold))
          .padding(.bottom, 1)

        Text(assignment.dateCreated.toString(format: "MMMM d, yyyy"))
          .foregroundColor(.gray)
          .font(.system(size: 10, weight: .medium))
      }
      .padding(.trailing, 12)

      Image(systemName: assignment.iconName)
        .foregroundColor(.white)
        .background(
          Color
            .purpleColor
            .frame(width: 45, height: 45, alignment: .center)
            .cornerRadius(15)
        )
        .padding(.trailing, 10)
    }
    .padding(.vertical, 23)
    .padding(.trailing, 23)
    .padding(.leading, 23)
    .cardShadow(cornerRadius: 27)
    .frame(width: 220, height: 100)

  }
}

struct ChatAssignmentRow_Previews: PreviewProvider {

  static var assignment: Assignment = .empty

  static var previews: some View {
    ChatAssignmentRow(assignment: assignment)
      .previewLayout(.fixed(width: 270, height: 100))
  }
}
