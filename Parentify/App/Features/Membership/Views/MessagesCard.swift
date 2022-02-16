//
//  MessagesCard.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct MessagesCard: View {

  @State var isShowBalance = false

  private let months = Calendar.current.shortMonthSymbols

  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      HStack(alignment: .center) {
        Spacer()
      }
    }.cardShadow(cornerRadius: 23)
  }
}

struct DetailCard: View {

  var body: some View {
    HStack {
      Text("Chat")
        .foregroundColor(.black)
        .font(.system(size: 16, weight: .bold))
        .padding(.leading, 31)

      Spacer()

      Image("ArrowIcon")
        .resizable()
        .frame(width: 26, height: 26, alignment: .center)
        .shadow(radius: 3)
        .padding(.trailing, 21)
    }
    .padding(.vertical, 21)
    .cardShadow(cornerRadius: 23)
  }
}

struct DashboardCard_Previews: PreviewProvider {
  static var previews: some View {
    MessagesCard().previewLayout(.fixed(width: 300, height: 253))
    //DetailCard().previewLayout(.sizeThatFits)
  }
}

