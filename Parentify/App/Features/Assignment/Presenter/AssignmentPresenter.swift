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
  @Published var updateAssignmentState: ViewState<Bool> = .initiate
  @Published var updateFinishedAssignmentState: ViewState<Bool> = .initiate
  @Published var deleteAssignmentState: ViewState<Bool> = .initiate
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

  func updateAssignment(assignment: Assignment) {
    updateAssignmentState = .loading
    firebaseManager.updateAssignment(assignment: assignment.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.updateAssignmentState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.updateAssignmentState = .error(error: error)
        }
      }
    }
  }

  func updateFinishedAssignment(assignment: Assignment) {
    updateFinishedAssignmentState = .loading
    firebaseManager.updateFinishedAssignment(assignment: assignment.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.updateFinishedAssignmentState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.updateFinishedAssignmentState = .error(error: error)
        }
      }
    }
  }

  func deleteAssignment(assignment: Assignment) {
    deleteAssignmentState = .loading
    firebaseManager.deleteAssignment(assignment: assignment.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.deleteAssignmentState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.deleteAssignmentState = .error(error: error)
        }
      }
    }
  }

  func fetchAssignments() {
    assignmentsState = .loading
    firebaseManager.fetchAssignments { result in
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

  func fetchDetailAssignment(assignmentId: String) {
    assignmentDetailState = .loading
    firebaseManager.fetchDetailAssignment(assignmentId: assignmentId) { result in
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
