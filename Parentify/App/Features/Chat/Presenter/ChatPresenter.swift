//
//  ChatPresenter.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import Foundation

class ChatPresenter: ObservableObject {

  @Published var uploadChatState: ViewState<Bool> = .initiate
  @Published var deleteChatState: ViewState<Bool> = .initiate
  @Published var chatsState: ViewState<[Chat]> = .initiate
  @Published var unreadChatsState: ViewState<Int> = .initiate

  private let firebaseManager: FirebaseManager

  init(firebaseManager: FirebaseManager) {
    self.firebaseManager = firebaseManager
  }

  func uploadChat(chat: Chat) {
    uploadChatState = .loading
    firebaseManager.uploadChat(chat: chat.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.uploadChatState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.uploadChatState = .error(error: error)
        }
      }
    }
  }

  func deleteChat(chat: Chat) {
    deleteChatState = .loading
    firebaseManager.deleteChat(chat: chat.map()) { result in
      switch result {
      case .success(let isSuccess):
        self.deleteChatState = .success(data: isSuccess)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.deleteChatState = .error(error: error)
        }
      }
    }
  }


  func fetchChats() {
    chatsState = .loading
    firebaseManager.fetchChats { result in
      switch result {
      case .success(let data):
        self.chatsState = .success(data: data.map { $0.map() })
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.chatsState = .error(error: error)
        }
      }
    }
  }

  func stopChats() {
    firebaseManager.stopChats()
  }

  func fetchUnreadChats() {
    unreadChatsState = .loading
    firebaseManager.fetchUnreadChats { result in
      switch result {
      case .success(let data):
        self.unreadChatsState = .success(data: data)
      case .failure(let firebaseError):
        if case .invalidRequest(let error) = firebaseError {
          self.unreadChatsState = .error(error: error)
        }
      }
    }
  }

}
