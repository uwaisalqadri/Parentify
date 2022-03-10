//
//  AssignmentPresenter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Combine
import Foundation

class AssignmentPresenter: ObservableObject {

  @Published var addAssignmentState: ViewState<Bool> = .initiate
  @Published var assignmentsState: ViewState<[Assignment]> = .initiate
  @Published var assignmentDetailState: ViewState<Assignment> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func addAssignment(assignment: Assignment) {
    addAssignmentState = .loading
    firebaseManager.addAssignment(assignment: assignment.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.addAssignmentState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.addAssignmentState = .error(error: error)
        }
      }
    }
  }

  func getAssignments() {
    assignmentsState = .loading
    firebaseManager.getAssignments { result in
      switch result {
      case .success(let data):
        self.assignmentsState = .success(data: data.map { $0.map() })
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.assignmentsState = .error(error: error)
        }
      }
    }
  }

  func getDetailAssignment(assignmentId: String) {
    assignmentDetailState = .loading
    firebaseManager.getDetailAssignment(assignmentId: assignmentId) { result in
      switch result {
      case .success(let data):
        self.assignmentDetailState = .success(data: data.map())
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.assignmentDetailState = .error(error: error)
        }
      }
    }
  }


}
