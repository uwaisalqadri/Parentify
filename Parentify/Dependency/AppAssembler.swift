//
//  AppAssembler.swift
//  Parentify (iOS)
//
//  Created by Uwais Alqadri on 2/14/22.
//

import Foundation

protocol Assembler: AssignmentAssembler,
                    ChatAssembler,
                    MembershipAssembler,
                    HomeAssembler {}

class AppAssembler: Assembler {
  static let shared = AppAssembler()
}
