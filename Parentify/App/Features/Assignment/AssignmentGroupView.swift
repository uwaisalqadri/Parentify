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

  @State var assignmentId: String = ""
  @State var assignmentType: AssigmnentType = .needToDone

  @State var isShowDetail: Bool = false
  @State var isAddAssignment: Bool = false

  @State var assignmentGroup: AssignmentGroup = .empty
  @State var selectedAssignment: Assignment = .empty
  let router: AssignmentRouter

  var onUploaded: (() -> Void)?

  var body: some View {
    VStack(alignment: .trailing) {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          ForEach(Array(assignmentGroup.assignments.enumerated()), id: \.offset) { index, item in
            NavigationLink(
              destination: router.routeAssignmentDetail(isParent: $isParent, assignmentId: assignmentId, assignmentType: selectedAssignment.type),
              isActive: $isShowDetail
            ) {
              AssignmentRow(
                assignment: item,
                isParent: $isParent,
                onSwipe: { action in
                  if case .finished(let assignment) = action {
                    presenter.updateFinishedAssignment(assignment: assignment)
                  }
                },
                onDelete: { assignment in
                  presenter.deleteAssignment(assignment: assignment)
                },
                onShowDetail: { assignmentId in
                  self.assignmentId = assignmentId
                  isShowDetail.toggle()
                }
              ).padding(.top, 12)
            }.buttonStyle(FlatLinkStyle())

          }.padding(.horizontal, 22)

          if presenter.assignmentsState != .loading && assignmentGroup.assignments.isEmpty {
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
        destination: router.routeAssignmentDetail(isParent: $isParent, assignmentId: assignmentId) {
          presenter.fetchAssignments()
          onUploaded?()
        },
        isActive: $isAddAssignment
      ) {
        EmptyView()
      }.buttonStyle(FlatLinkStyle())
    )
    .onAppear {
      assignmentGroup = getAssignmentGroups(assignments: [])[0]
      presenter.fetchLiveAssignments()
    }
    .onDisappear(perform: {
      presenter.stopAssignments()
    })
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
  }

}
