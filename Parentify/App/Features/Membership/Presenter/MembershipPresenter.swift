//
//  MembershipPresenter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

class MembershipPresenter: ObservableObject {

  @Published var userState: ViewState<User> = .initiate
  @Published var createUserState: ViewState<Bool> = .initiate
  @Published var loginState: ViewState<Bool> = .initiate
  @Published var logoutState: ViewState<Bool> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func getUser() {
    userState = .loading
    firebaseManager.getUser { result in
      switch result {
      case .success(let data):
        self.userState = .success(data: data.map())
      case .failure(let error):
        self.userState = .error(error: error)
      }
    }
  }

  func createUser(user: User) {
    createUserState = .loading
    firebaseManager.createUser(user: user.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.createUserState = .success(data: isSuccess)
      case .failure(let error):
        self.createUserState = .error(error: error)
      }
    }
  }

  func loginUser(email: String, password: String) {
    loginState = .loading
    firebaseManager.loginUser(email: email, password: password) { result in
      switch result {
      case .success(let data):
        self.loginState = .success(data: data)
      case .failure(let error):
        self.loginState = .error(error: error)
      }
    }
  }

  func logoutUser() {
    logoutState = .loading
    firebaseManager.logoutUser { result in
      switch result {
      case .success(let data):
        self.logoutState = .success(data: data)
      default:
        break
      }
    }
  }

}
