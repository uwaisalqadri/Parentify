//
//  FirebaseManager.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorageSwift
import FirebaseFirestoreSwift

typealias CompletionResult<T> = (Result<T, FirebaseError>) -> Void

enum FirebaseError: Error {
  case cantCreateUser
  case invalidRequest(error: Error)
  case unknownError
}

protocol FirebaseManager {

  // MARK: Membership
  func registerUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func loginUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func logoutUser(completion: @escaping CompletionResult<Bool>)
  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func updateUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func getUser(completion: @escaping CompletionResult<UserEntity>)

  // MARK: Assignment
  func addAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)

  // MARK: Messages
  func addMessage(message: MessageEntity, completion: @escaping CompletionResult<Bool>)
  func getMessages(completion: @escaping CompletionResult<[MessageEntity]>)
}

class DefaultFirebaseManager: FirebaseManager {

  private let firebaseAuth = Auth.auth()
  private let firestoreDatabase = Firestore.firestore()

  // MARK: Membership

  func registerUser(email: String, password: String, completion: @escaping CompletionResult<Bool>) {
    firebaseAuth.createUser(withEmail: email, password: password) { result, error in
      if let error = error {
        completion(.failure(.invalidRequest(error: error)))
      } else {
        completion(.success(true))
      }
    }
  }

  func loginUser(email: String, password: String, completion: @escaping CompletionResult<Bool>) {
    firebaseAuth.signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        completion(.failure(.invalidRequest(error: error)))
      } else {
        completion(.success(true))
      }
    }
  }

  func logoutUser(completion: @escaping CompletionResult<Bool>) {
    do {
      try firebaseAuth.signOut()
      completion(.success(true))
    } catch {
      completion(.success(false))
    }
  }

  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>) {
    guard let email = user.email else { return }
    firestoreDatabase
      .collection(Constant.membership)
      .document(email)
      .setData(user.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func updateUser(user: UserEntity, completion: @escaping CompletionResult<Bool>) {
    guard let email = user.email else { return }
    firestoreDatabase
      .collection(Constant.membership)
      .document(email)
      .updateData(user.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func getUser(completion: @escaping CompletionResult<UserEntity>) {
    guard let email = firebaseAuth.currentUser?.email else { return }
    firestoreDatabase
      .collection(Constant.membership)
      .document(email)
      .getDocument { snapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else {
          let result = Result { try snapshot?.data(as: UserEntity.self) }
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

  // MARK: Assigment

  func addAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>) {
    guard let assignmentId = assignment.id else { return }
    firestoreDatabase
      .collection(Constant.assignment)
      .document(assignmentId)
      .setData(assignment.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  // MARK: Messages

  func addMessage(message: MessageEntity, completion: @escaping CompletionResult<Bool>) {
    guard let messageId = message.id else { return }
    firestoreDatabase
      .collection(Constant.messages)
      .document(messageId)
      .setData(message.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func getMessages(completion: @escaping CompletionResult<[MessageEntity]>) {
    firestoreDatabase
      .collection(Constant.messages)
      .order(by: "datetime", descending: true)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot {
          var messages = [MessageEntity]()
          for document in querySnapshot.documents {
            do {
              if let message = try document.data(as: MessageEntity.self) {
                messages.append(message)
              }
              completion(.success(messages))
            } catch {
              completion(.failure(.unknownError))
            }
          }
        }
      }
  }

}
