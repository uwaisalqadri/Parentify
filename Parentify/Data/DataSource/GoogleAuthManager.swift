//
//  GoogleAuthManager.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/6/22.
//

import SwiftUI
import GoogleSignIn
import Firebase

class GoogleAuthManager: ObservableObject {

  enum AuthState {
    case signedIn
    case signedOut
  }

  @Published var state: AuthState = .signedOut

  func signIn() {
    if GIDSignIn.sharedInstance.hasPreviousSignIn() {
      GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
        self?.authenticateUser(for: user, with: error)
      }
    } else {
      guard let clientID = FirebaseApp.app()?.options.clientID,
            let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }

      let configuration = GIDConfiguration(clientID: clientID)

      print("CLIENT_ID", clientID, "CONFIGS", configuration)

      GIDSignIn.sharedInstance.signIn(with: configuration, presenting: presentingViewController) { [weak self] user, error in
        self?.authenticateUser(for: user, with: error)
      }
    }
  }

  func signOut() {
    GIDSignIn.sharedInstance.signOut()

    do {
      try Auth.auth().signOut()
      state = .signedOut
    } catch {
      print(error.localizedDescription)
    }
  }

  private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }

    guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

    Auth.auth().signIn(with: credential) { [weak self] _, error in
      guard let self = self else { return }
      if let error = error {
        print(error.localizedDescription)
      } else {
        self.state = .signedIn
      }
    }
  }

}
