//
//  DefaultError.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import Foundation

enum DefaultError: Error {
  case noResult
  case invalidRequest(error: Error)
}
