//
//  MembershipPresenter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

class MembershipPresenter: ObservableObject {

  @Published var userState: ViewState<Bool> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func createUser(user: User) {
    userState = .loading
    firebaseManager.createUser(user: user.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.userState = .success(data: isSuccess)
      case .failure(let error):
        self.userState = .error(error: error)
      }
    }
  }
}
