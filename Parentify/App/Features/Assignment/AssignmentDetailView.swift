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
  @State var assignmentType: AssigmnentType = .additional
  @State private var sortOrder: SortOrder = .defaultOrder

  @State var assignment: Assignment = .initialize
  @State var title: String = "Judul"
  @State var description: String = "Deskripsi"
  @State var imageSystemName: String = "plus"
  @State var selectedImage: UIImage = UIImage()

  @State var isShowPicker: Bool = false
  @State var isSelectIcon: Bool = false

  var onUploaded: (() -> Void)?

  init(presenter: AssignmentPresenter, assignmentId: String = "", assignmentType: AssigmnentType = .additional, onUploaded: (() -> Void)? = nil) {
    self.presenter = presenter
    self.assignmentId = assignmentId
    self.assignmentType = assignmentType
    self.onUploaded = onUploaded

    if !assignmentId.isEmpty {
      presenter.getDetailAssignment(assignmentId: assignmentId)
    }
  }

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
            id: assignmentId.isEmpty ? UUID() : UUID(uuidString: assignmentId)!,
            iconName: imageSystemName,
            title: title,
            description: description,
            type: assignmentType,
            dateCreated: Date(),
            attachments: [selectedImage.toJpegString(compressionQuality: 0.5) ?? ""],
            assignedTo: []
          )

          if !assignmentId.isEmpty {
            presenter.updateAssignment(assignment: assignment)
          } else {
            presenter.addAssignment(assignment: assignment)
          }
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
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button(action: {
          isSelectIcon.toggle()
        }) {
          Image(systemName: imageSystemName)
            .foregroundColor(.purpleColor)
        }

        Menu {
          Picker(selection: $assignmentType, label: Text("Sort")) {
            ForEach(AssigmnentType.allCases, id: \.self) { type in
              Text(type.rawValue == "need_to_done" ? "Harus Dikerjakan" : "Tambahan").tag(type)
            }
          }
        } label: {
          Image(systemName: "ellipsis.circle.fill")
        }
      }
    }
    .onReceive(presenter.$addAssignmentState) { state in
      if case .success = state {
        presentationMode.wrappedValue.dismiss()
        onUploaded?()
      }
    }
    .onReceive(presenter.$updateAssignmentState) { state in
      if case .success = state {
        presentationMode.wrappedValue.dismiss()
        onUploaded?()
      }
    }
    .onReceive(presenter.$assignmentDetailState) { state in
      if case .success(let data) = state {
        assignment = data
        assignmentId = assignment.id.uuidString
        title = assignment.title
        description = assignment.description
        imageSystemName = assignment.iconName
        assignmentType = assignment.type
        assignment.attachments.forEach { attachment in
          selectedImage = attachment.toImage() ?? UIImage()
        }
      }
    }
    .onTapGesture {
      hideKeyboard()
    }
    .sheet(isPresented: $isShowPicker) {
      ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
    }
    .showSheet(isPresented: $isSelectIcon) {
      SelectIconView(sfSymbols: AppAssembler.shared.resolve()) { symbol in
        imageSystemName = symbol.name
        isSelectIcon.toggle()
      }
    }
    .onAppear {
      if !assignmentId.isEmpty {
        presenter.getDetailAssignment(assignmentId: assignmentId)
      }
    }

  }
}
