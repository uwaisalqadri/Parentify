//
//  AssignmentDetailView.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/16/22.
//

import SwiftUI

struct AssignmentDetailView: View {

  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var presenter: AssignmentPresenter
  @State var assignmentId: String = ""

  @State var assignment: Assignment = .initialize
  @State var title: String = "Judul"
  @State var description: String = "Deskripsi"
  @State var selectedImage: UIImage = UIImage()
  @State var isShowPicker: Bool = false

  var onUploaded: (() -> Void)?

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        Image(uiImage: selectedImage.size.width != 0 ? selectedImage : UIImage(named: "ImgAttachFile")!)
          .resizable()
          .scaledToFit()
          .cornerRadius(12)
          .frame(height: 200)
          .padding(.top, 30)
          .padding(.horizontal, 10)
          .onTapGesture {
            isShowPicker.toggle()
          }

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
          assignment = .init(
            iconName: "",
            title: title,
            description: description,
            type: .additional,
            dateCreated: Date(),
            attachments: [selectedImage.toJpegString(compressionQuality: 0.5) ?? ""],
            assignedTo: []
          )

          presenter.addAssignment(assignment: assignment)
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
    .progressHUD(isShowing: $presenter.assignmentDetailState.isLoading)
    .progressHUD(isShowing: $presenter.addAssignmentState.isLoading)
    .padding(.horizontal, 20)
    .navigationTitle(assignment.title)
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $isShowPicker) {
      ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
    }
    .onReceive(presenter.$addAssignmentState) { state in
      if case .success = state {
        presentationMode.wrappedValue.dismiss()
        onUploaded?()
      }
    }
    .onReceive(presenter.$assignmentDetailState) { state in
      if case .success(let data) = state {
        assignment = data
        title = assignment.title
        description = assignment.description
        assignment.attachments.forEach { attachment in
          selectedImage = attachment.toImage() ?? UIImage()
        }
      }
    }
    .onTapGesture {
      hideKeyboard()
    }
    .onAppear {
      if !assignmentId.isEmpty {
        presenter.getDetailAssignment(assignmentId: assignmentId)
      }
    }

  }
}
