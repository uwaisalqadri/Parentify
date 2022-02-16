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

  var body: some Scene {
    WindowGroup {
      HomeView(router: assembler.resolve(), assignmentRouter: assembler.resolve())
        .onAppear {
          FirebaseApp.configure()
        }
    }
  }
}
