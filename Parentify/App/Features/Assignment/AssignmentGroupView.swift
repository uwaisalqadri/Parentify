//
//  AssignmentGroupView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

enum SortOrder: String, CaseIterable {
  case defaultOrder = "Sorted by Default"
  case name = "Sorted by Name"
}

struct AssignmentGroupView: View {

  @State var isShowDetail: Bool = false
  @State private var sortOrder: SortOrder = .defaultOrder

  var assignmentGroup: AssignmentGroup
  let router: AssignmentRouter

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {

        ForEach(Array(assignmentGroup.assignments.enumerated()), id: \.offset) { index, item in
          let nextView: AssignmentDetailView = router.route()
          NavigationLink(destination: nextView, isActive: $isShowDetail) {
            AssignmentItemView(
              assignment: item,
              onShowDetail: {
                isShowDetail.toggle()
              }).padding(.top, 12)

          }.buttonStyle(FlatLinkStyle())
        }.padding(.horizontal, 22)
      }

    }.navigationTitle(assignmentGroup.title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Picker(selection: $sortOrder, label: Text("Sort")) {
            ForEach(SortOrder.allCases, id: \.self) { order in
              Text(order.rawValue).tag(order)
            }
          }
        } label: {
          Image(systemName: "ellipsis.circle.fill")
        }
      }
    }
  }

}
