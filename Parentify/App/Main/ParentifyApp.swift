//
//  ParentifyApp.swift
//  Shared
//
//  Created by Uwais Alqadri on 2/14/22.
//

import SwiftUI
import Firebase
import UserNotifications

@main
struct ParentifyApp: App {

  @StateObject var authManager: GoogleAuthManager = GoogleAuthManager()
  private var isSignedIn: Bool = false

  private let router: HomeRouter = AppAssembler.shared.resolve()

  init() {
    FirebaseApp.configure()
    registerUserNotification()

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

func pushUserNotification(title: String, message: String) {
  let content = UNMutableNotificationContent()
  content.title = title
  content.body = message
  content.sound = UNNotificationSound.default

  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
  let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

  UNUserNotificationCenter.current().add(request)
}

func registerUserNotification() {
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
    if success {
      print("All set")
    } else if let error = error {
      print(error.localizedDescription)
    }
  }
}
