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
  func signInUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signOutUser(completion: @escaping CompletionResult<Bool>)
  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func updateUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func getUser(completion: @escaping CompletionResult<UserEntity>)

  // MARK: Assignment
  func addAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func updateAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func deleteAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func updateFinishedAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func getAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>)
  func getDetailAssignment(assignmentId: String, completion: @escaping CompletionResult<AssignmentEntity>)

  // MARK: Messages
  func addMessage(message: MessageEntity, completion: @escaping CompletionResult<Bool>)
  func getMessages(completion: @escaping CompletionResult<[MessageEntity]>)

  // MARK: Chat
  func uploadChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>)
  func deleteChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>)
  func getChats(completion: @escaping CompletionResult<[ChatEntity]>)
  func getUnreadChats(completion: @escaping CompletionResult<Int>)
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

  func signInUser(email: String, password: String, completion: @escaping CompletionResult<Bool>) {
    firebaseAuth.signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        completion(.failure(.invalidRequest(error: error)))
        completion(.success(false))
      } else {
        completion(.success(true))
      }
    }
  }

  func signOutUser(completion: @escaping CompletionResult<Bool>) {
    do {
      try firebaseAuth.signOut()
      completion(.success(true))
    } catch {
      completion(.failure(.invalidRequest(error: error)))
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
  func getAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>) {
    firestoreDatabase
      .collection(Constant.assignment)
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

  func getDetailAssignment(assignmentId: String, completion: @escaping CompletionResult<AssignmentEntity>) {
    firestoreDatabase
      .collection(Constant.assignment)
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

  func updateAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>) {
    guard let assignmentId = assignment.id else { return }
    firestoreDatabase
      .collection(Constant.assignment)
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
    firestoreDatabase
      .collection(Constant.assignment)
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
    firestoreDatabase
      .collection(Constant.assignment)
      .document(assignmentId)
      .delete { error in
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
      //.order(by: "datetime", descending: true)
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

  func uploadChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>) {
    guard let chatId = chat.id else { return }
    firestoreDatabase
      .collection(Constant.chat)
      .document(chatId)
      .setData(chat.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func deleteChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>) {
    guard let chatId = chat.id else { return }
    firestoreDatabase
      .collection(Constant.chat)
      .document(chatId)
      .delete { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func getChats(completion: @escaping CompletionResult<[ChatEntity]>) {
    firestoreDatabase
      .collection(Constant.chat)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot {
          var chats = [ChatEntity]()
          for document in querySnapshot.documents {
            do {
              if let chat = try document.data(as: ChatEntity.self) {
                chats.append(chat)
              }
              completion(.success(chats))
            } catch {
              completion(.failure(.unknownError))
            }
          }
        }
      }
  }

  func getUnreadChats(completion: @escaping CompletionResult<Int>) {
    firestoreDatabase
      .collection(Constant.chat)
      .whereField("is_read", isEqualTo: false)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot {
          var chats = [ChatEntity]()
          for document in querySnapshot.documents {
            do {
              if let chat = try document.data(as: ChatEntity.self) {
                chats.append(chat)
              }
              completion(.success(chats.count))
            } catch {
              completion(.failure(.unknownError))
            }
          }
        }
      }
  }

}
