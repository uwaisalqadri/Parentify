//
//  MemojiView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/19/22.
//

import SwiftUI

struct MemojiView: View {

  @Binding var profileImage: UIImage
  @Binding var isShowMemojiTextView: Bool

  var body: some View {
    NavigationView {
      MemojiTextView(image: $profileImage)
        .onChange(of: profileImage) { value in
          profileImage = value
          isShowMemojiTextView = false
        }
        .navigationTitle("Memoji")
        .toolbar {
          ToolbarItem(id: "done") {
            Button(action: {
              isShowMemojiTextView = false
            }) {
              Text("Done")
                .foregroundColor(.purpleColor)
            }
          }
        }
    }.navigationViewStyle(.stack)
  }
}
