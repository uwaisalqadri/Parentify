//
//  ContentView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/18/22.
//

import SwiftUI

struct ContentView: View {

  @EnvironmentObject var googleAuthManager: GoogleAuthManager

  let isSignedIn: Bool
  let router: HomeRouter

  var body: some View {
    ZStack {
      if isSignedIn {
        router.routeHome()
      } else {
        router.routeSignIn()
      }
    }
  }

}
