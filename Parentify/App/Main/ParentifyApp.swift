//
//  ParentifyApp.swift
//  Shared
//
//  Created by Uwais Alqadri on 2/14/22.
//

import SwiftUI
import Firebase

@main
struct ParentifyApp: App {

  private let assembler = AppAssembler()
  private var isLoggedIn = false

  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      if isLoggedIn {
        HomeView(router: assembler.resolve(), assignmentRouter: assembler.resolve())
      } else {
        LoginView(presenter: assembler.resolve())
      }
    }
  }
}
