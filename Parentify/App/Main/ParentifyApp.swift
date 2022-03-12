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

  @StateObject var authManager: GoogleAuthManager = GoogleAuthManager()

  private let assembler = AppAssembler()
  private var isSignedIn = false

  init() {
    FirebaseApp.configure()
    self.isSignedIn = Auth.auth().currentUser != nil
  }

  var body: some Scene {
    WindowGroup {
      ContentView(assembler: assembler, isSignedIn: isSignedIn)
        .environment(\.colorScheme, .light)
        .environmentObject(authManager)
    }
  }
}
