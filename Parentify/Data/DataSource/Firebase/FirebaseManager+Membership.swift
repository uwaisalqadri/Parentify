//
//  FirebaseManager+Membership.swift
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
    firestoreCollection(.membership)
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
    firestoreCollection(.membership)
      .document(email)
      .updateData(user.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func fetchUser(completion: @escaping CompletionResult<UserEntity>) {
    guard let email = firebaseAuth.currentUser?.email else { return }
    firestoreCollection(.membership)
      .document(email)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else {
          let result = Result { try querySnapshot?.data(as: UserEntity.self) }
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

  func fetchUsers(isChildren: Bool = false, completion: @escaping CompletionResult<[UserEntity]>) {
    firestoreCollection(.membership)
      .whereRoleIsChildren(isChildren: isChildren)
      .getDocuments { querySnapshot, error in
        if let error = error {
          completion(.failure(.invalidRequest(error: error)))
        } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
          var users = [UserEntity]()
          for document in querySnapshot.documents {
            do {
              if document.exists {
                if let user = try document.data(as: UserEntity.self) {
                  users.append(user)
                }
                completion(.success(users))
              } else {
                completion(.failure(.cantCreateUser))
              }
            } catch {
              completion(.failure(.unknownError))
            }
          }
        }
      }
  }

  func addMessage(message: MessageEntity, completion: @escaping CompletionResult<Bool>) {
    guard let messageId = message.id else { return }
    firestoreCollection(.messages)
      .document(messageId)
      .setData(message.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func fetchMessages(completion: @escaping CompletionResult<[MessageEntity]>) {
    firestoreCollection(.messages)
      .orderByDate(recordDate: .message, descending: true)
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
