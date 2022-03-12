//
//  AsignmentItemView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

enum Action {
  case finished
  case none
}

struct AssignmentGroupItemView: View {

  @Binding var isShowDetail: Bool
  @Binding var isParent: Bool

  var assignmentGroup: AssignmentGroup
  var router: AssignmentRouter
  var onDelete: ((Assignment) -> Void)?
  var onUploaded: (() -> Void)?

  @State var actionTitle: String = "Lihat Semuanya"
  @State var selectedAssignment: Assignment = .initialize

  var body: some View {
    HStack {
      Text(assignmentGroup.title)
        .foregroundColor(.black)
        .font(.system(size: 17, weight: .bold))

      Spacer()

      NavigationLink(
        destination: router.routeAssignmentGroup(
          isParent: $isParent,
          assignmentType: assignmentGroup.type
        ) {
          onUploaded?()
        }
      ) {
        Text(actionTitle)
          .foregroundColor(.purpleColor)
          .font(.system(size: 13, weight: .medium))
      }.buttonStyle(FlatLinkStyle())

    }
    .padding(.top, 43)
    .padding(.horizontal, 32)

    ForEach(Array(assignmentGroup.assignments.prefix(3).enumerated()), id: \.offset) { index, item in
      NavigationLink(
        destination: router.routeAssignmentDetail(assignmentId: selectedAssignment.id.uuidString),
        isActive: $isShowDetail
      ) {
        AssignmentItemView(assignment: item, isParent: $isParent) { action in
          print("action", action)
        } onDelete: { assignment in
          onDelete?(assignment)
        } onShowDetail: { assignment in
          selectedAssignment = assignment
          isShowDetail.toggle()
        }
      }.buttonStyle(FlatLinkStyle())

    }
    .padding(.horizontal, 25)
    .padding(.top, 12)

    if assignmentGroup.assignments.isEmpty {
      HStack(alignment: .center) {
        Spacer()

        VStack(alignment: .center) {
          Image(systemName: "highlighter")
            .resizable()
            .foregroundColor(.purpleColor)
            .frame(width: 40, height: 40)

          Text("Add Assignment")
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.purpleColor)
        }

        Spacer()
      }
      .padding(.vertical, 40)
    }

  }
}

struct AssignmentItemView: View {

  var assignment: Assignment
  @Binding var isParent: Bool

  var onSwipe: ((Action) -> Void)? = nil
  var onDelete: ((Assignment) -> Void)? = nil
  var onShowDetail: ((Assignment) -> Void)? = nil

  var body: some View {
    ZStack(alignment: .topTrailing) {

      Text("Done")
        .foregroundColor(.green)
        .font(.system(size: 15, weight: .bold))
        .padding([.top, .trailing], 30)

      AssignmentCard(isParent: _isParent, assignment: assignment, onSwipe: onSwipe, onDelete: onDelete, onShowDetail: onShowDetail)

    }.padding(.bottom, 50)
  }
}

struct AssignmentCard: View {

  @State private var translation: CGSize = .zero
  @State private var swipeAction: Action = .none
  private var thresholdPercentage: CGFloat = 0.5 //  draged 50% the width of the screen in either direction

  @Binding private var isParent: Bool
  private var assignment: Assignment
  private var onSwipe: ((Action) -> Void)?
  private var onDelete: ((Assignment) -> Void)?
  private var onShowDetail: ((Assignment) -> Void)?

  private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
    gesture.translation.width / geometry.size.width
  }

  init(
    isParent: Binding<Bool>,
    assignment: Assignment,
    onSwipe: ((Action) -> Void)? = nil,
    onDelete: ((Assignment) -> Void)? = nil,
    onShowDetail: ((Assignment) -> Void)? = nil
  ) {
    self._isParent = isParent
    self.assignment = assignment
    self.onSwipe = onSwipe
    self.onDelete = onDelete
    self.onShowDetail = onShowDetail
  }

  var body: some View {
    GeometryReader { geometry in
      HStack {
        Image(systemName: assignment.iconName)
          .foregroundColor(.white)
          .background(
            Color
              .purpleColor
              .frame(width: 45, height: 45, alignment: .center)
              .cornerRadius(15)
          )
          .padding(.leading, 10)

        VStack(alignment: .leading) {
          Text(assignment.title)
            .foregroundColor(.black)
            .font(.system(size: 14, weight: .semibold))

          Text(assignment.dateCreated.toString(format: "MMMM d, yyyy"))
            .foregroundColor(.gray)
            .font(.system(size: 14, weight: .medium))
        }.padding(.leading, 20)

        Spacer()
      }
      .padding(30)
      .cardShadow(cornerRadius: 23)
      .frame(height: 100, alignment: .leading)
      .animation(.interactiveSpring())
      .offset(x: translation.width, y: 0)
      .gesture(
        DragGesture()
          .onChanged { value in
            if !isParent {
              translation = value.translation
              if (getGesturePercentage(geometry, from: value)) >= thresholdPercentage {
                swipeAction = .finished
              } else {
                swipeAction = .none
              }
            }

          }.onEnded { value in
            if !isParent {
              if getGesturePercentage(geometry, from: value) > thresholdPercentage {
                onSwipe?(swipeAction)
                translation = .init(width: 700, height: 0)
              } else if getGesturePercentage(geometry, from: value) < -thresholdPercentage {
                onSwipe?(swipeAction)
                translation = .init(width: -700, height: 0)
              } else {
                translation = .zero
              }
            }
          }
      )
      .contextMenu {
        Button(action: {
          onShowDetail?(assignment)
        }) {
          Label("Detail", systemImage: "info.circle.fill")
        }

        if isParent {
          if #available(iOS 15.0, *) {
            Button(role: .destructive) {
              onDelete?(assignment)
            } label: {
              Label("Remove", systemImage: "trash.fill")
            }
          } else {
            Button(action: {
              onDelete?(assignment)
            }) {
              Label("Remove", systemImage: "trash.fill")
            }
          }
        }

      }
    }
  }
}

