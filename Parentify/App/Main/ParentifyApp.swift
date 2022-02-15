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
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          FirebaseApp.configure()
        }
    }
  }
}
