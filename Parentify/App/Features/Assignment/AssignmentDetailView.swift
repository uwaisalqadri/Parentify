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
  @ObservedObject var membershipPresenter: MembershipPresenter

  @State private var assignment: Assignment = .empty
  @State private var assignmentType: AssigmnentType = .additional
  @State private var sortOrder: SortOrder = .defaultOrder

  @State private var title: String = "Judul"
  @State private var description: String = "Deskripsi"
  @State private var imageSystemName: String = "plus"
  @State private var selectedImage: UIImage = UIImage()
  @State private var assignedUsers = [User]()
  @State private var children = [User]()

  @State private var isShowPicker: Bool = false
  @State private var isSelectIcon: Bool = false
  @State private var isShowChat: Bool = false

  let isParent: Bool
  let assignmentId: String
  let router: AssignmentRouter
  var onUploaded: (() -> Void)?

  init(presenter: AssignmentPresenter, membershipPresenter: MembershipPresenter, router: AssignmentRouter, isParent: Bool, assignmentId: String, assignmentType: AssigmnentType = .additional, onUploaded: (() -> Void)? = nil) {
    self.presenter = presenter
    self.membershipPresenter = membershipPresenter
    self.router = router
    self.isParent = isParent
    self.assignmentId = assignmentId
    self.assignmentType = assignmentType
    self.onUploaded = onUploaded

    if !assignmentId.isEmpty {
      presenter.fetchDetailAssignment(assignmentId: assignmentId)
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
          .allowsHitTesting(isParent)
          .onTapGesture {
            isShowPicker.toggle()
          }

        TextEditor(text: $title)
          .font(.system(size: 23, weight: .bold))
          .lineLimit(2)
          .frame(height: 40)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .disabled(!isParent)
          .padding(.horizontal, 5)

        TextEditor(text: $description)
          .font(.system(size: 15, weight: .regular))
          .multilineTextAlignment(.leading)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .disabled(!isParent)
          .padding(.horizontal, 5)
          .fixedSize(horizontal: false, vertical: true)

        if isParent {
          AttachUserView(
            users: Array(assignedUsers.prefix(children.count)),
            onAttachUser: {
              children.forEach {
                assignedUsers.append($0)
              }
            },
            onDetachUser: { index in
              assignedUsers.remove(at: index)
            }
          )
        }

        Spacer()

        if isParent {
          Button(action: {
            let assignment: Assignment = .init(
              id: assignmentId.isEmpty ? UUID().uuidString : assignmentId,
              iconName: imageSystemName,
              title: title,
              description: description,
              type: assignmentType,
              dateCreated: Date(),
              attachments: [selectedImage.toJpegString(compressionQuality: 0.5) ?? ""],
              assignedTo: assignedUsers
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
        }

        Button(action: {
          isShowChat.toggle()
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
    .navigationViewStyle(.stack)
    .fullScreenCover(isPresented: $isShowChat) {
      NavigationView {
        router.routeChatChannel(assignment: assignment)
          .navigationBarBackButtonHidden(false)
      }
    }
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
              Text(type.rawValue == "need_to_done" ? "Harus Dikerjakan" : "Tambahan")
                .tag(type)
            }
          }
        } label: {
          Image(systemName: "ellipsis.circle.fill")
        }
      }
    }
    .onViewStatable(
      presenter.$addAssignmentState,
      onSuccess: { _ in
        presentationMode.wrappedValue.dismiss()
        onUploaded?()
      }
    )
    .onViewStatable(
      presenter.$updateAssignmentState,
      onSuccess: { _ in
        presentationMode.wrappedValue.dismiss()
        onUploaded?()
      }
    )
    .onViewStatable(
      presenter.$assignmentDetailState,
      onSuccess: { data in
        assignment = data
        title = assignment.title
        description = assignment.description
        imageSystemName = assignment.iconName
        assignmentType = assignment.type
        assignedUsers = assignment.assignedTo
        assignment.attachments.forEach { attachment in
          selectedImage = attachment.toImage() ?? UIImage()
        }
      }
    )
    .onViewStatable(
      membershipPresenter.$allUserState,
      onSuccess: { data in
        children = data
      }
    )
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
        presenter.fetchDetailAssignment(assignmentId: assignmentId)
      }

      if isParent {
        membershipPresenter.fetchUsers(isChildren: true)
      }
    }

  }
}
