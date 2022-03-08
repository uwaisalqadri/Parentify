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

  @Binding var isParent: Bool
  @State private var sortOrder: SortOrder = .defaultOrder

  @State var isShowDetail: Bool = false
  @State var isAddAssignment: Bool = false

  var assignmentGroup: AssignmentGroup
  let router: AssignmentRouter

  var body: some View {
    VStack(alignment: .trailing) {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {

          ForEach(Array(assignmentGroup.assignments.enumerated()), id: \.offset) { index, item in
            AssignmentItemView(
              assignment: item,
              onShowDetail: {
                isShowDetail.toggle()
              }).padding(.top, 12)
          }.padding(.horizontal, 22)
        }
      }

      if isParent {
        Button(action: {
          isShowDetail.toggle()
        }) {
          VStack {
            Image(systemName: "plus")
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundColor(.white)
              .padding()
          }
          .cardShadow(backgroundColor: .purpleColor, cornerRadius: 30)
          .padding(20)
        }
      }
    }
    .navigationTitle(assignmentGroup.title)
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
    .background(
      NavigationLink(destination: router.routeAssignmentDetail(), isActive: $isShowDetail) {
        EmptyView()
      }.buttonStyle(FlatLinkStyle())
    )
  }

}
