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
  @Published var registerState: ViewState<Bool> = .initiate
  @Published var loginState: ViewState<Bool> = .initiate
  @Published var logoutState: ViewState<Bool> = .initiate

  @Published var isLoading: Bool = false
  @Published var isSuccessLogin: Bool = false
  @Published var isSuccessRegister: Bool = false

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func getUser() {
    isLoading = true
    firebaseManager.getUser { result in
      switch result {
      case .success(let data):
        self.userState = .success(data: data.map())
        self.isLoading = false
      case .failure(let error):
        self.userState = .error(error: error)
        self.isLoading = false
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

  func registerUser(email: String, password: String) {
    registerState = .loading
    firebaseManager.registerUser(email: email, password: password) { result in
      switch result {
      case .success(let isSuccess):
        self.registerState = .success(data: isSuccess)
        self.isSuccessRegister = isSuccess
      case .failure(let error):
        self.registerState = .error(error: error)
      }
    }
  }

  func loginUser(email: String, password: String) {
    loginState = .loading
    firebaseManager.loginUser(email: email, password: password) { result in
      switch result {
      case .success(let isSuccess):
        self.loginState = .success(data: isSuccess)
        self.isSuccessLogin = isSuccess
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
