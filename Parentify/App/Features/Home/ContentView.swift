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
  let assembler: Assembler

  var body: some View {
    ZStack {
      if isSignedIn {
        HomeView(membershipPresenter: assembler.resolve(), assignmentPresenter: assembler.resolve(), chatPresenter: assembler.resolve(), presenter: assembler.resolve(), router: assembler.resolve(), assignmentRouter: assembler.resolve())
      } else {
        SignInView(presenter: assembler.resolve(), router: assembler.resolve())
      }
    }

  }
}
