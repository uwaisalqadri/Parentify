//
//  BaseBody.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/17/22.
//

import Foundation

protocol BodyCodable {
  func asFormDictionary() -> [String: Any]
}

extension BodyCodable where Self: Codable {
  func asFormDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            return [:]
          }
    return dict
  }
}

