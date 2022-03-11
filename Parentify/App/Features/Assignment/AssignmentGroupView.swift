//
//  AssignmentGroupView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentGroupView: View {

  @Environment(\.presentationMode) var presentationMode

  @Binding var isParent: Bool
  @State private var sortOrder: SortOrder = .defaultOrder

  @State var isShowDetail: Bool = false
  @State var isAddAssignment: Bool = false

  @State var assignmentGroup: AssignmentGroup = .initialize
  @State var selectedAssignment: Assignment = .initialize
  let router: AssignmentRouter

  var onUploaded: (() -> Void)?

  var body: some View {
    VStack(alignment: .trailing) {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          ForEach(Array(assignmentGroup.assignments.enumerated()), id: \.offset) { index, item in
            NavigationLink(
              destination: router.routeAssignmentDetail(assignmentId: selectedAssignment.id.uuidString, assignmentType: selectedAssignment.type),
              isActive: $isShowDetail
            ) {
              AssignmentItemView(
                assignment: item,
                onShowDetail: { assignment in
                  selectedAssignment = assignment
                  isShowDetail.toggle()
                }).padding(.top, 12)
            }.buttonStyle(FlatLinkStyle())

          }.padding(.horizontal, 22)

          if assignmentGroup.assignments.isEmpty {
            HStack(alignment: .center) {
              Spacer()

              VStack(alignment: .center) {
                Image(systemName: "highlighter")
                  .resizable()
                  .foregroundColor(.purpleColor)
                  .frame(width: 60, height: 60)

                Text("Add Assignment")
                  .font(.system(size: 20, weight: .semibold))
                  .foregroundColor(.purpleColor)
              }

              Spacer()
            }
            .padding(.vertical, 60)
          }

        }
      }

      if isParent {
        HStack {
          Spacer()

          Button(action: {
            isAddAssignment.toggle()
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
      NavigationLink(
        destination: router.routeAssignmentDetail() {
          onUploaded?()
          presentationMode.wrappedValue.dismiss()
        },
        isActive: $isAddAssignment
      ) {
        EmptyView()
      }.buttonStyle(FlatLinkStyle())
    )
  }

}
