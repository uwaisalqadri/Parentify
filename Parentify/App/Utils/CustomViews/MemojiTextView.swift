//
//  MemojiTextView.swift
//  Celengan
//
//  Created by Uwais Alqadri on 1/20/22.
//

import SwiftUI

struct MemojiTextView: UIViewRepresentable {

  @Binding private var image: UIImage
  private var textView = UIMemojiTextView()

  init(image: Binding<UIImage>) {
    textView.allowsEditingTextAttributes = true
    textView.clearsOnInsertion = true
    self._image = image
  }

  func makeUIView(context: Context) -> UIMemojiTextView {
    textView.delegate = context.coordinator
    return textView
  }

  func updateUIView(_ uiView: UIMemojiTextView, context: Context) {}

  func makeCoordinator() -> MemojiTextView.Coordinator {
    return Coordinator(image: $image)
  }
}

extension MemojiTextView {

  class Coordinator: NSObject, UITextViewDelegate {
    @Binding var image: UIImage

    init(image: Binding<UIImage>) {
      self._image = image
    }

    func textViewDidChange(_ textView: UITextView) {
      textView.attributedText.enumerateAttributes(in: NSRange(location: 0, length: textView.attributedText.length), options: .init(rawValue: 0)) { attribute, range, _ in

        attribute.values.forEach { value in
          guard let attachment = value as? NSTextAttachment,
                  let image = attachment.image else { return }
          self.image = image
        }
      }
    }

  }
}

class UIMemojiTextView: UITextView {
  override var textInputContextIdentifier: String? { "" }

  override var textInputMode: UITextInputMode? {
    for mode in UITextInputMode.activeInputModes {
      if mode.primaryLanguage == "emoji" {
        return mode
      }
    }
    return nil
  }
}
