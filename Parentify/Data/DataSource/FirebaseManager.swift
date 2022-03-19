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
  func fetchUser(completion: @escaping CompletionResult<UserEntity>)
  func fetchUsers(completion: @escaping CompletionResult<[UserEntity]>)
  func stopUsers()
  func stopUser()

  // MARK: Assignment
  func addAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func updateAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func deleteAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func updateFinishedAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func fetchAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>)
  func fetchLiveAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>)
  func fetchDetailAssignment(assignmentId: String, completion: @escaping CompletionResult<AssignmentEntity>)
  func stopAssignments()

  // MARK: Messages
  func addMessage(message: MessageEntity, completion: @escaping CompletionResult<Bool>)
  func fetchMessages(completion: @escaping CompletionResult<[MessageEntity]>)

  // MARK: Chat
  func addChatChannel(channel: ChatChannelEntity, completion: @escaping CompletionResult<Bool>)
  func fetchChannels(completion: @escaping CompletionResult<[ChatChannelEntity]>)
  func uploadChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>)
  func deleteChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>)
  func fetchChats(completion: @escaping CompletionResult<[ChatEntity]>)
  func fetchUnreadChats(completion: @escaping CompletionResult<Int>)
  func stopChats()
  func stopChannels()

}

class DefaultFirebaseManager: FirebaseManager {

  static let shared: DefaultFirebaseManager = DefaultFirebaseManager()
  let firebaseAuth = Auth.auth()

  private var chatListener: ListenerRegistration?
  private var channelListener: ListenerRegistration?
  private var usersListener: ListenerRegistration?
  private var userListener: ListenerRegistration?
  private var assignmentListener: ListenerRegistration?

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
    if userListener == nil {
      userListener = firestoreCollection(.membership)
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
  }

  func fetchUsers(completion: @escaping CompletionResult<[UserEntity]>) {
    if usersListener == nil {
      usersListener = firestoreCollection(.membership)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            completion(.failure(.invalidRequest(error: error)))
          } else if let querySnapshot = querySnapshot {
            var users = [UserEntity]()
            for document in querySnapshot.documents {
              do {
                if let user = try document.data(as: UserEntity.self) {
                  users.append(user)
                }
                completion(.success(users))
              } catch {
                completion(.failure(.unknownError))
              }
            }
          }
        }
    }
  }

  func stopUsers() {
    if usersListener != nil {
      usersListener?.remove()
      usersListener = nil
    }
  }

  func stopUser() {
    if userListener != nil {
      userListener?.remove()
      userListener = nil
    }
  }

}

extension DefaultFirebaseManager {

  func fetchAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>) {
    firestoreCollection(.assignment)
      .orderByDate(recordDate: .assignment)
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

  func fetchLiveAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>) {
    if assignmentListener == nil {
      assignmentListener = firestoreCollection(.assignment)
        .orderByDate(recordDate: .assignment)
        .addSnapshotListener { querySnapshot, error in
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
  }

  func fetchDetailAssignment(assignmentId: String, completion: @escaping CompletionResult<AssignmentEntity>) {
    firestoreCollection(.assignment)
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
    firestoreCollection(.assignment)
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
    firestoreCollection(.assignment)
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
    firestoreCollection(.assignment)
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
    firestoreCollection(.assignment)
      .document(assignmentId)
      .delete { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func stopAssignments() {
    if assignmentListener != nil {
      assignmentListener?.remove()
      assignmentListener = nil
    }
  }

}

extension DefaultFirebaseManager {

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
      .orderByDate(recordDate: .message)
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

extension DefaultFirebaseManager {

  func addChatChannel(channel: ChatChannelEntity, completion: @escaping CompletionResult<Bool>) {
    guard let channelId = channel.id else { return }
    firestoreCollection(.channel)
      .document(channelId)
      .setData(channel.asFormDictionary()) { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func fetchChannels(completion: @escaping CompletionResult<[ChatChannelEntity]>) {
    if channelListener == nil {
      channelListener = firestoreCollection(.channel)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            completion(.failure(.invalidRequest(error: error)))
          } else if let querySnapshot = querySnapshot {
            var channels = [ChatChannelEntity]()
            for document in  querySnapshot.documents {
              do {
                if let channel = try document.data(as: ChatChannelEntity.self) {
                  channels.append(channel)
                }
                completion(.success(channels))
              } catch {
                completion(.failure(.unknownError))
              }
            }
          }
        }
    }
  }

  func stopChannels() {
    if channelListener != nil {
      channelListener?.remove()
      channelListener = nil
    }
  }

  func uploadChat(chat: ChatEntity, completion: @escaping CompletionResult<Bool>) {
    guard let chatId = chat.id else { return }
    firestoreCollection(.chat)
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
    firestoreCollection(.chat)
      .document(chatId)
      .delete { error in
        if let error = error {
          return completion(.failure(.invalidRequest(error: error)))
        } else {
          return completion(.success(true))
        }
      }
  }

  func fetchUnreadChats(completion: @escaping CompletionResult<Int>) {
    firestoreCollection(.chat)
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

  func fetchChats(completion: @escaping CompletionResult<[ChatEntity]>) {
    if chatListener == nil {
      chatListener = firestoreCollection(.chat)
        .orderByDate(recordDate: .chat)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            completion(.failure(.invalidRequest(error: error)))
          } else if let querySnapshot = querySnapshot {
            var chats = [ChatEntity]()
            for document in  querySnapshot.documents {
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
  }

  func stopChats() {
    if chatListener != nil {
      chatListener?.remove()
      chatListener = nil
    }
  }

}
