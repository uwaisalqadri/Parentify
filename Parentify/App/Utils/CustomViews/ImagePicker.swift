//
//  ImagePicker.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/7/22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

  @Binding var selectedImage: UIImage
  @Environment(\.presentationMode) private var presentationMode

  var sourceType: UIImagePickerController.SourceType = .photoLibrary

  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        parent.selectedImage = image
      }

      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
