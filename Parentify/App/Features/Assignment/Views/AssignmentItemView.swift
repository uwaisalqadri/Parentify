//
//  AsignmentItemView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

enum Action {
  case remove
  case unpaid
  case none
}

struct AssignmentGroupItemView: View {

  @Binding var isShowDetail: Bool
  @Binding var isParent: Bool

  var assignmentGroup: AssignmentGroup
  var router: AssignmentRouter
  var actionTitle: String = "Lihat Semuanya"
  var onDelete: ((Int) -> Void)?

  var body: some View {
    HStack {
      Text(assignmentGroup.title)
        .foregroundColor(.black)
        .font(.system(size: 17, weight: .bold))

      Spacer()

      NavigationLink(destination: router.routeAssignmentGroup(isParent: $isParent, assignmentGroup: assignmentGroup)) {
        Text(actionTitle)
          .foregroundColor(.purpleColor)
          .font(.system(size: 13, weight: .medium))
      }.buttonStyle(FlatLinkStyle())

    }
    .padding(.top, 43)
    .padding(.horizontal, 32)

    ForEach(Array(assignmentGroup.assignments.prefix(3).enumerated()), id: \.offset) { index, item in
      NavigationLink(destination: router.routeAssignmentDetail(), isActive: $isShowDetail) {
        AssignmentItemView(assignment: item) { action in
          print("action", action)
        } onDelete: {
          onDelete?(index)
        } onShowDetail: {
          isShowDetail.toggle()
        }
      }.buttonStyle(FlatLinkStyle())

    }.padding(.horizontal, 25)
    .padding(.top, 12)
  }
}

struct AssignmentItemView: View {

  var assignment: Assignment
  var onSwipe: ((Action) -> Void)? = nil
  var onDelete: (() -> Void)? = nil
  var onShowDetail: (() -> Void)? = nil

  var body: some View {
    ZStack(alignment: .topTrailing) {

      Text("Paid")
        .foregroundColor(.green)
        .font(.system(size: 15, weight: .bold))
        .padding([.top, .trailing], 30)

      AssignmentCard(assignment: assignment, onSwipe: onSwipe, onDelete: onDelete, onShowDetail: onShowDetail)

    }.padding(.bottom, 50)
  }
}

struct AssignmentCard: View {

  @State private var translation: CGSize = .zero
  @State private var swipeAction: Action = .none
  private var thresholdPercentage: CGFloat = 0.5 //  draged 50% the width of the screen in either direction

  private var assignment: Assignment
  private var onSwipe: ((Action) -> Void)?
  private var onDelete: (() -> Void)?
  private var onShowDetail: (() -> Void)?

  private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
    gesture.translation.width / geometry.size.width
  }

  init(
    assignment: Assignment,
    onSwipe: ((Action) -> Void)? = nil,
    onDelete: (() -> Void)? = nil,
    onShowDetail: (() -> Void)? = nil
  ) {
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

        VStack(alignment: .leading) {
          Text(assignment.title)
            .foregroundColor(.black)
            .font(.system(size: 14, weight: .semibold))

          Text(assignment.dateCreated.toString())
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
              translation = value.translation
              if (getGesturePercentage(geometry, from: value)) >= thresholdPercentage {
                swipeAction = .unpaid
              } else if getGesturePercentage(geometry, from: value) <= -thresholdPercentage {
                swipeAction = .remove
              } else {
                swipeAction = .none
              }

            }.onEnded { value in
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
        )
        .onTapGesture {
          print("clicked")
        }
        .contextMenu {
          Button(action: {
            onShowDetail?()
          }) {
            Label("Detail", systemImage: "info.circle.fill")
          }

          if #available(iOS 15.0, *) {
            Button(role: .destructive) {
              onDelete?()
            } label: {
              Label("Remove", systemImage: "trash.fill")
            }
          } else {
            Button(action: {
              onDelete?()
            }) {
              Label("Remove", systemImage: "trash.fill")
            }
          }
        }
    }
  }
}

