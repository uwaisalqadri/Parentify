//
//  AssignmentGroupView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentGroupView: View {

  @ObservedObject var presenter: AssignmentPresenter
  @ObservedObject var membershipPresenter: MembershipPresenter

  @State private var currentUser: User = .empty
  @State private var assignmentId: String = ""

  @State private var isShowDetail: Bool = false
  @State private var isAddAssignment: Bool = false

  @State private var assignmentGroup: AssignmentGroup = getAssignmentGroups(assignments: [])[0]
  @State private var selectedAssignment: Assignment = .empty

  let isParent: Bool

  let assignmentType: AssigmnentType
  let router: AssignmentRouter

  var onUploaded: (() -> Void)?

  var body: some View {
    VStack(alignment: .trailing) {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          ForEach(Array(assignmentGroup.assignments.enumerated()), id: \.offset) { index, item in
            NavigationLink(
              destination: router.routeAssignmentDetail(isParent: isParent, assignmentId: assignmentId, assignmentType: selectedAssignment.type),
              isActive: $isShowDetail
            ) {
              AssignmentRow(
                assignment: item,
                isParent: isParent,
                onSwipe: { action in
                  if case .finished(let assignment) = action {
                    presenter.updateFinishedAssignment(assignment: .init(
                      id: assignment.id,
                      iconName: assignment.iconName,
                      title: assignment.title,
                      description: assignment.description,
                      type: assignment.type,
                      dateCreated: assignment.dateCreated,
                      attachments: assignment.attachments,
                      assignedTo: assignment.assignedTo,
                      isDone: true
                    ))
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

          if assignmentGroup.assignments.isEmpty {
            HStack(alignment: .center) {
              Spacer()

              VStack(alignment: .center) {
                Image(systemName: "highlighter")
                  .resizable()
                  .foregroundColor(.purpleColor)
                  .frame(width: 60, height: 60)

                Text("Tambahkan Tugas, Reminder, atau Important Task")
                  .font(.system(size: 15, weight: .semibold))
                  .foregroundColor(.purpleColor)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal, 40)
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
    .background(
      NavigationLink(
        destination: router.routeAssignmentDetail(isParent: isParent, assignmentId: assignmentId) {
          onUploaded?()
        }, isActive: $isAddAssignment
      ) {
        EmptyView()
      }.buttonStyle(FlatLinkStyle())
    )
    .onAppear {
      membershipPresenter.fetchUser()
      presenter.fetchLiveAssignments()
    }
    .onDisappear {
      presenter.stopAssignments()
    }
    .onViewStatable(
      membershipPresenter.$userState,
      onSuccess: { data in
        currentUser = data
      }
    )
    .onViewStatable(
      presenter.$assignmentsState,
      onSuccess: { data in
        let needToDone = data.filter { $0.type == .needToDone }
        let additional = data.filter { $0.type == .additional }

        switch assignmentType {
        case .needToDone:
          assignmentGroup = getAssignmentGroups(
            assignments: isParent ? needToDone : needToDone.filterAssignedAssignments(currentUser: currentUser)
          )[0]
        case .additional:
          assignmentGroup = getAssignmentGroups(
            assignments: isParent ? additional : additional.filterAssignedAssignments(currentUser: currentUser)
          )[1]
        }
      }
    )
  }

}
