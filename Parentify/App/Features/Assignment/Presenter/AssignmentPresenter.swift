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

}
