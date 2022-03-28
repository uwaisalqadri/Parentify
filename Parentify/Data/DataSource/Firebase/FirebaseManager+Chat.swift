//
//  FirebaseManager+Chat.swift
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
