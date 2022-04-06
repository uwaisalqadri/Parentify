//
//  AssignmentGroupRow.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

enum Action {
  case finished(assignment: Assignment)
  case none
}

struct AssignmentGroupRow: View {

  let router: AssignmentRouter
  let selectedAssignmentId: String

  @Binding var isShowDetail: Bool
  let isParent: Bool

  let assignmentGroup: AssignmentGroup
  var onSwipe: ((Action) -> Void)?
  var onDelete: ((Assignment) -> Void)?
  var onShowDetail: ((String) -> Void)?
  var onUploaded: (() -> Void)?

  @State var actionTitle: String = "Lihat Semuanya"

  var body: some View {
    HStack {
      Text(assignmentGroup.title)
        .foregroundColor(.black)
        .font(.system(size: 17, weight: .bold))

      Spacer()

      NavigationLink(
        destination: router.routeAssignmentGroup(isParent: isParent, assignmentType: assignmentGroup.type, onUploaded: onUploaded)
      ) {
        Text(actionTitle)
          .foregroundColor(.purpleColor)
          .font(.system(size: 13, weight: .medium))

      }.buttonStyle(FlatLinkStyle())

    }
    .padding(.top, 43)
    .padding(.horizontal, 32)

    ForEach(Array(assignmentGroup.assignments.prefix(3).enumerated()), id: \.offset) { index, item in
      AssignmentRow(
        assignment: item,
        isParent: isParent,
        onSwipe: onSwipe,
        onDelete: onDelete,
        onShowDetail: onShowDetail
      )
    }
    .padding(.horizontal, 25)
    .padding(.top, 12)
    .overlay(
      NavigationLink(
        destination: router.routeAssignmentDetail(isParent: isParent, assignmentId: selectedAssignmentId),
        isActive: $isShowDetail
      ) {
        EmptyView()
      }, alignment: .center
    )

    if assignmentGroup.assignments.isEmpty {
      HStack(alignment: .center) {
        Spacer()

        VStack(alignment: .center) {
          Image(systemName: "highlighter")
            .resizable()
            .foregroundColor(.purpleColor)
            .frame(width: 40, height: 40)

          Text("Tambahkan Tugas, Reminder, atau Important Task")
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.purpleColor)
            .padding(.horizontal, 40)
        }

        Spacer()
      }
      .padding(.vertical, 40)
    }

  }
}

struct AssignmentRow: View {

  let assignment: Assignment
  let isParent: Bool

  var onSwipe: ((Action) -> Void)? = nil
  var onDelete: ((Assignment) -> Void)? = nil
  var onShowDetail: ((String) -> Void)? = nil

  var body: some View {
    ZStack(alignment: .topTrailing) {

      Text("Selesai")
        .foregroundColor(.green)
        .font(.system(size: 15, weight: .bold))
        .padding([.top, .trailing], 30)

      AssignmentCard(
        isParent: isParent,
        assignment: assignment,
        onSwipe: onSwipe,
        onDelete: onDelete,
        onShowDetail: onShowDetail
      )
      .onTapGesture {
        onShowDetail?(assignment.id)
      }

    }.padding(.bottom, 50)
  }
}

struct AssignmentCard: View {

  @State private var translation: CGSize = .zero
  @State private var swipeAction: Action = .none
  private var thresholdPercentage: CGFloat = 0.5 //  draged 50% the width of the screen in either direction

  private let isParent: Bool
  private let assignment: Assignment

  private var onSwipe: ((Action) -> Void)?
  private var onDelete: ((Assignment) -> Void)?
  private var onShowDetail: ((String) -> Void)?

  private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
    gesture.translation.width / geometry.size.width
  }

  init(
    isParent: Bool,
    assignment: Assignment,
    onSwipe: ((Action) -> Void)? = nil,
    onDelete: ((Assignment) -> Void)? = nil,
    onShowDetail: ((String) -> Void)? = nil
  ) {
    self.isParent = isParent
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

          Text(assignment.dateCreated.toString(format: "h:mm a, d MMMM yyyy"))
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
                swipeAction = .none
              } else {
                swipeAction = .finished(assignment: assignment)
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
          onShowDetail?(assignment.id)
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

