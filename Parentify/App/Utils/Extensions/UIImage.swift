//
//  UIImage.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/20/22.
//

import SwiftUI

extension UIImage {
  func toPngString() -> String? {
    let data = self.pngData()
    return data?.base64EncodedString(options: .endLineWithLineFeed)
  }
  
  func toJpegString(compressionQuality cq: CGFloat) -> String? {
    let data = self.jpegData(compressionQuality: cq)
    return data?.base64EncodedString(options: .endLineWithLineFeed)
  }
}
