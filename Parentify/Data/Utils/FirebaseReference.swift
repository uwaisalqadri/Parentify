//
//  FirebaseReference.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/15/22.
//

import Foundation
import Firebase

enum FirestoreCollection: String {
  case assignment
  case chat
  case membership
  case messages

}

func firestoreCollection(_ collectionRefrence: FirestoreCollection) -> CollectionReference {
  return Firestore.firestore().collection(collectionRefrence.rawValue)
}
