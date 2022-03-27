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
  private var isSignedIn: Bool = false

  private let assembler = AppAssembler()

  init() {
    FirebaseApp.configure()
    isSignedIn = DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil
    print("isSignedIn", isSignedIn, DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil)
  }

  var body: some Scene {
    WindowGroup {
      ContentView(isSignedIn: isSignedIn, assembler: assembler)
        .environment(\.colorScheme, .light)
        .environmentObject(authManager)
    }
  }
}
