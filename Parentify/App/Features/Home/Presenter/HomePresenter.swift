//
//  HomePresenter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

class HomePresenter: ObservableObject {

  @Published var messagesState: ViewState<[Message]> = .initiate
  @Published var addMessageState: ViewState<Bool> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func addMessage(message: Message) {
    addMessageState = .loading
    firebaseManager.addMessage(message: message.map()) { result in
      switch result {
      case .success(let data):
        self.addMessageState = .success(data: data)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.addMessageState = .error(error: error)
        }
      }
    }
  }

  func getMessages() {
    messagesState = .loading
    firebaseManager.getMessages { result in
      switch result {
      case .success(let data):
        self.messagesState = .success(data: data.map { $0.map() })
        print("HALLO", data)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.messagesState = .error(error: error)
        }
      }
    }
  }

}
