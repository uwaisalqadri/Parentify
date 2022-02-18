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
    self.isLoggedIn = Auth.auth().currentUser != nil
  }

  var body: some Scene {
    WindowGroup {
      ContentView(assembler: assembler, isLoggedIn: isLoggedIn)
    }
  }
}
