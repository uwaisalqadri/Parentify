//
//  Error.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import Foundation
import Firebase

extension Error {
  var firAuthError: Error? {
    (self as NSError).userInfo["FIRAuthErrorDomain"] as? Error
  }
}
