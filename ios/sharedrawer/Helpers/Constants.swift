//
//  Constants.swift
//  ShareDrawerUI
//
//  Created by Ajay on 28/10/21.
//

import UIKit

struct Constants {
  static let lightBlack = UIColor(red: 43/255, green: 42/255, blue: 41/255, alpha: 1)
  static let lightGray = UIColor(red: 65/255, green: 68/255, blue: 71/255, alpha: 1)
  static let purple = UIColor(red: 108/255, green: 103/255, blue: 242/255, alpha: 1)
  static let green = UIColor(red: 68/255, green: 161/255, blue: 59/255, alpha: 1)
  static let red = UIColor(red: 0.714, green: 0.161, blue: 0.192, alpha: 1)
  static let blueBlack = UIColor(red: 0.294, green: 0.365, blue: 0.42, alpha: 1)
  static let pureBlack = UIColor(red: 0.169, green: 0.165, blue: 0.161, alpha: 1)
  static let lightBlackLabel = UIColor(red: 0.537, green: 0.58, blue: 0.612, alpha: 1)
  static let imageHeight =  58 * 0.7
  static let rowHeight: CGFloat = 58
  static let groupName: String = "group.com.paletteedu.palette.sharedrawer"
  static let appBundleId = "com.paletteedu.palette"
  static let sharedURLString = "SharedURLConstant"
  static let shareDrawerNavigateKey = "shareDrawerNavigateKey";
  enum OnboardingType {
      case Todo
      case Opportunity
      case Chat
  }
}
