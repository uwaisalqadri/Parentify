//
//  FirebaseManager+Assignment.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/28/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorageSwift
import FirebaseFirestoreSwift

extension DefaultFirebaseManager {

  func fetchAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>) {
    firestoreCollection(.assignment)
      .orderByDate(recordDate: .assignment)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot {
          var assignments = [AssignmentEntity]()
          for document in querySnapshot.documents {
            do {
              if let assignment = try document.data(as: AssignmentEntity.self) {
                assignments.append(assignment)
              }
              completion(.success(assignments))
            } catch {
              completion(.failure(.unknownError))
            }
          }
        }
      }
  }

  func fetchLiveAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>) {
    if assignmentListener == nil {
      assignmentListener = firestoreCollection(.assignment)
        .orderByDate(recordDate: .assignment)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            completion(.failure(.invalidRequest(error: error)))
          } else if let querySnapshot = querySnapshot {
            var assignments = [AssignmentEntity]()
            for document in querySnapshot.documents {
              do {
                if let assignment = try document.data(as: AssignmentEntity.self) {
                  assignments.append(assignment)
                }
                completion(.success(assignments))
              } catch {
                completion(.failure(.unknownError))
              }
            }
          }
        }
    }
  }

  func fetchDetailAssignment(assignmentId: String, completion: @escaping CompletionResult<AssignmentEntity>) {
    firestoreCollection(.assignment)
      .document(assignmentId)
      .getDocument { snapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else {
          let result = Result { try snapshot?.data(as: AssignmentEntity.self) }
          switch result {
          case .success(let data):
            if let data = data {
              completion(.success(data))
            }
          case .failure:
            completion(.failure(.unknownError))
          }
        }
      }
  }

  func addAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>) {
    guard let assignmentId = assignment.id else { return }
    firestoreCollection(.assignment)
      .document(assignmentId)
      .setData(assignment.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func updateAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>) {
    guard let assignmentId = assignment.id else { return }
    firestoreCollection(.assignment)
      .document(assignmentId)
      .updateData(assignment.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func updateFinishedAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>) {
    guard let assignmentId = assignment.id else { return }
    firestoreCollection(.assignment)
      .document(assignmentId)
      .updateData(assignment.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func deleteAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>) {
    guard let assignmentId = assignment.id else { return }
    firestoreCollection(.assignment)
      .document(assignmentId)
      .delete { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func fetchAssignmentWithMessage(completion: @escaping CompletionResult<(assignment: AssignmentEntity, message: MessageEntity)>) {

    fetchAssignments { assignmentResult in
      if case .success(let assignments) = assignmentResult {
        self.fetchMessages { messageResult in
          if case .success(let messages) = messageResult {
            guard let assignment = assignments.first, let message = messages.first else { return }
            completion(.success((assignment: assignment, message: message)))
          } else {
            completion(.failure(.unknownError))
          }
        }
      } else {
        completion(.failure(.unknownError))
      }
    }
  }

  func stopAssignments() {
    if assignmentListener != nil {
      assignmentListener?.remove()
      assignmentListener = nil
    }
  }

}
