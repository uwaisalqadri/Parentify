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

typealias CompletionResult<T> = (Result<T, FirebaseError>) -> Void

enum FirebaseError: Error {
  case cantCreateUser
  case invalidRequest(error: Error)
  case unknownError
}

protocol FirebaseManager {
  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func loginUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func getUser(completion: @escaping CompletionResult<UserEntity>)
}

class DefaultFirebaseManager: FirebaseManager {

  private let firebaseAuth = Auth.auth()
  private let firestoreDatabase = Firestore.firestore()

  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>) {
    guard let email = user.email, let password = user.password else { return }
    firebaseAuth.createUser(withEmail: email, password: password) { result, error in
      if error == nil {
        self.firestoreDatabase
          .collection(Constant.membership)
          .document(email)
          .setData(user.asFormDictionary()) { error in
            if error != nil, let error = error {
              return completion(.failure(.invalidRequest(error: error)))
            }
          }
        completion(.success(true))
      } else {
        completion(.failure(.cantCreateUser))
      }
    }
  }

  func loginUser(email: String, password: String, completion: @escaping CompletionResult<Bool>) {
    firebaseAuth.signIn(withEmail: email, password: password) { result, error in
      if error != nil, let error = error {
        completion(.failure(.invalidRequest(error: error)))
      } else {
        completion(.success(true))
      }
    }
  }

  func getUser(completion: @escaping CompletionResult<UserEntity>) {

  }
}
