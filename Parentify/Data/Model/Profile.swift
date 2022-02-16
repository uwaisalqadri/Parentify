//
//  ProfileItem.swift
//  Celengan
//
//  Created by Uwais Alqadri on 2/11/22.
//

import SwiftUI

struct Profile {
  static let initialize: Profile = Profile()

  var name: String = ""
  var email: String = ""
  var profilePict: UIImage = UIImage()
  var isDarkMode: Bool = false
  var isMonthlyEnable: Bool = false
  var monthlyIncome: Int = 0
  var payDate: Date = Date()
}
