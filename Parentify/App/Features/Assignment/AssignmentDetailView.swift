//
//  AssignmentDetailView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentDetailView: View {

  @State var title: String = "Judul"
  @State var description: String = "Deskripsi"

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        Image("ImgAttachFile")
          .resizable()
          .frame(height: 200)
          .padding(.top, 30)
          .padding(.horizontal, 10)

        TextEditor(text: $title)
          .font(.system(size: 23, weight: .bold))
          .lineLimit(2)
          .frame(height: 40)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.horizontal, 5)

        TextEditor(text: $description)
          .font(.system(size: 15, weight: .regular))
          .frame(height: 200)
          .multilineTextAlignment(.leading)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.horizontal, 5)

        Spacer()

        Button(action: {
          print("Simpan")
        }) {
          HStack {
            Spacer()

            Text("Simpan")
              .foregroundColor(.white)
              .font(.system(size: 15, weight: .bold))

            Spacer()
          }
        }
        .padding(15)
        .cardShadow(backgroundColor: .purpleColor, cornerRadius: 15)
        .padding(.top, 17)
        .padding(.horizontal, 20)

        Button(action: {
          print("Chat")
        }) {
          HStack {
            Spacer()

            Text("Chat")
              .foregroundColor(.white)
              .font(.system(size: 15, weight: .bold))

            Spacer()
          }
        }
        .padding(15)
        .cardShadow(backgroundColor: .pinkColor, cornerRadius: 15)
        .padding(.top, 17)
        .padding(.horizontal, 20)

      }
    }
    .padding(.horizontal, 20)
    .navigationTitle("Mengerjakan PR")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct AssignmentDetailView_Previews: PreviewProvider {

  @State static var isShow: Bool = false

  static var previews: some View {
    Button(action: {
      isShow.toggle()
    }) {
      Text("Oke")
    }
    .showSheet(isPresented: .constant(true)) {
      AssignmentDetailView()
    }
  }
}
