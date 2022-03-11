//
//  AssignmentGroupView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentGroupView: View {

  @ObservedObject var presenter: AssignmentPresenter

  @Binding var isParent: Bool
  @State var assignmentType: AssigmnentType = .needToDone

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
                onDelete: { assignment in
                  presenter.deleteAssignment(assignment: assignment)
                },
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
    .progressHUD(isShowing: $presenter.assignmentsState.isLoading)
    .background(
      NavigationLink(
        destination: router.routeAssignmentDetail() {
          presenter.getAssignments()
          onUploaded?()
        },
        isActive: $isAddAssignment
      ) {
        EmptyView()
      }.buttonStyle(FlatLinkStyle())
    )
    .onAppear {
      presenter.getAssignments()
    }
    .onReceive(presenter.$assignmentsState) { state in
      if case .success(let data) = state {
        let needToDone = data.filter { $0.type == .needToDone }
        let additional = data.filter { $0.type == .additional }

        switch assignmentType {
        case .needToDone:
          assignmentGroup = getAssignmentGroups(assignments: needToDone)[0]
        case .additional:
          assignmentGroup = getAssignmentGroups(assignments: additional)[1]
        }
      }
    }
    .onReceive(presenter.$deleteAssignmentState) { state in
      if case .success = state {
        presenter.getAssignments()
      }
    }
  }

}
