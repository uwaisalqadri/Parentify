//
//  ContentView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/18/22.
//

import SwiftUI

struct ContentView: View {

  let assembler: Assembler
  var isSignedIn: Bool

  var body: some View {
    if isSignedIn {
      HomeView(membershipPresenter: assembler.resolve(), assignmentPresenter: assembler.resolve(), chatPresenter: assembler.resolve(), presenter: assembler.resolve(), router: assembler.resolve())
    } else {
      SignInView(presenter: assembler.resolve(), router: assembler.resolve())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(assembler: AppAssembler.shared, isSignedIn: false)
  }
}
