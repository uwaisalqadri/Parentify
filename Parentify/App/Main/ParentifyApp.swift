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

  private let router: HomeRouter = AppAssembler.shared.resolve()

  init() {
    FirebaseApp.configure()
    isSignedIn = DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil
  }

  var body: some Scene {
    WindowGroup {
      ContentView(isSignedIn: isSignedIn, router: router)
        .environment(\.colorScheme, .light)
        .environmentObject(authManager)
    }
  }
}
