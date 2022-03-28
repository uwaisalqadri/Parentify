//
//  FirebaseError.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/28/22.
//

import Foundation

enum FirebaseError: Error {
  case cantCreateUser
  case invalidRequest(error: Error)
  case unknownError
}
