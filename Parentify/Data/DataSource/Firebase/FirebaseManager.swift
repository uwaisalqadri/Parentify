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

protocol FirebaseManager {

  func registerUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signInUser(email: String, password: String, completion: @escaping CompletionResult<Bool>)
  func signOutUser(completion: @escaping CompletionResult<Bool>)
  func createUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func updateUser(user: UserEntity, completion: @escaping CompletionResult<Bool>)
  func fetchUser(completion: @escaping CompletionResult<UserEntity>)
  func fetchUsers(isChildren: Bool, completion: @escaping CompletionResult<[UserEntity]>)
  func stopUser()

  func addAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func updateAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func deleteAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func updateFinishedAssignment(assignment: AssignmentEntity, completion: @escaping CompletionResult<Bool>)
  func fetchAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>)
  func fetchLiveAssignments(completion: @escaping CompletionResult<[AssignmentEntity]>)
  func fetchDetailAssignment(assignmentId: String, completion: @escaping CompletionResult<AssignmentEntity>)
  func fetchAssignmentWithMessage(completion: @escaping CompletionResult<(assignment: AssignmentEntity, message: MessageEntity)>)
  func stopAssignments()

  func addMessage(message: MessageEntity, completion: @escaping CompletionResult<Bool>)
  func fetchMessages(completion: @escaping CompletionResult<[MessageEntity]>)

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

  var chatListener: ListenerRegistration?
  var channelListener: ListenerRegistration?
  var userListener: ListenerRegistration?
  var assignmentListener: ListenerRegistration?

}
