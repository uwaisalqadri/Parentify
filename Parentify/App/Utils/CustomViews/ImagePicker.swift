//
//  ImagePicker.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/7/22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

  var sourceType: UIImagePickerController.SourceType = .photoLibrary

  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType

    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

  }
}
