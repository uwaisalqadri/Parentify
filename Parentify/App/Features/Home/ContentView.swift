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
    NavigationView {
      if isLoggedIn {
        HomeView(presenter: assembler.resolve(), router: assembler.resolve(), assignmentRouter: assembler.resolve())
      } else {
        LoginView(presenter: assembler.resolve(), router: assembler.resolve())
      }
    }
//    .simultaneousGesture(
//      TapGesture().onEnded { _ in
//        hideKeyboard()
//      }
//    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(assembler: AppAssembler.shared, isLoggedIn: false)
  }
}
