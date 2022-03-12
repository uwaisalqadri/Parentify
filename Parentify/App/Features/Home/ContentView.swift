//
//  ContentView.swift
//  Parentify
//
//  Created by Uwais Alqadri on 2/18/22.
//

import SwiftUI

struct ContentView: View {

  let assembler: Assembler
  var isLoggedIn: Bool

  var body: some View {
    if isLoggedIn {
      HomeView(membershipPresenter: assembler.resolve(), assignmentPresenter: assembler.resolve(), presenter: assembler.resolve(), router: assembler.resolve(), assignmentRouter: assembler.resolve())
    } else {
      SignInView(presenter: assembler.resolve(), router: assembler.resolve())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(assembler: AppAssembler.shared, isLoggedIn: false)
  }
}
