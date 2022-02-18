//
//  ViewState.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/14/22.
//

import Foundation

enum ViewState<T> {
  case initiate
  case loading
  case empty
  case error(error: Error)
  case success(data: T)

  var value: T? {
    if case .success(let data) = self {
      return data
    }
    return nil
  }

  var isLoading: Bool {
    if case .loading = self {
      return true
    }
    return false
  }
}
