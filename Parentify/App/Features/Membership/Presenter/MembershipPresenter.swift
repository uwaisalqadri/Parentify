//
//  MembershipPresenter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

class MembershipPresenter: ObservableObject {

  @Published var userState: ViewState<User> = .initiate
  @Published var allUserState: ViewState<[User]> = .initiate
  @Published var createUserState: ViewState<Bool> = .initiate
  @Published var updateUserState: ViewState<Bool> = .initiate
  @Published var registerState: ViewState<Bool> = .initiate
  @Published var signInState: ViewState<Bool> = .initiate
  @Published var signOutState: ViewState<Bool> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func fetchUser() {
    userState = .loading
    firebaseManager.fetchUser { result in
      switch result {
      case .success(let data):
        self.userState = .success(data: data.map())
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.userState = .error(error: error)
        }
      }
    }
  }

  func stopUser() {
    firebaseManager.stopUser()
  }

  func fetchUsers(isChildren: Bool = false) {
    allUserState = .loading
    firebaseManager.fetchUsers(isChildren: isChildren) { result in
      switch result {
      case .success(let data):
        self.allUserState = .success(data: data.map { $0.map() })
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.allUserState = .error(error: error)
        }
      }
    }
  }

  func createUser(user: User) {
    createUserState = .loading
    firebaseManager.createUser(user: user.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.createUserState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.createUserState = .error(error: error)
        }
      }
    }
  }

  func updateUser(user: User) {
    updateUserState = .loading
    firebaseManager.updateUser(user: user.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.updateUserState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.updateUserState = .error(error: error)
        }
      }
    }
  }

  func registerUser(email: String, password: String) {
    registerState = .loading
    firebaseManager.registerUser(email: email, password: password) { result in
      switch result {
      case .success(let isSuccess):
        self.registerState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.registerState = .error(error: error)
        }
      }
    }
  }

  func signInUser(email: String, password: String) {
    signInState = .loading
    firebaseManager.signInUser(email: email, password: password) { result in
      switch result {
      case .success(let isSuccess):
        self.signInState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.signInState = .error(error: error)
        }
      }
    }
  }

  func signOutUser() {
    signOutState = .loading
    firebaseManager.signOutUser { result in
      switch result {
      case .success(let isSuccess):
        self.signOutState = .success(data: isSuccess)
      default:
        break
      }
    }
  }

}
