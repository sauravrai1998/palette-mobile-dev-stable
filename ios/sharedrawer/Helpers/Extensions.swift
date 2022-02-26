//
//  Extensions.swift
//  ShareDrawerUI
//
//  Created by Ajay on 28/10/21.
//

import UIKit

extension UIView {
  func addShadow() {
    layer.cornerRadius = 8
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 8
    layer.shadowOffset = CGSize(width: 0, height: 2)
  }
    func setBorder(radius:CGFloat, color:UIColor) {
            layer.cornerRadius = CGFloat(radius)
            layer.borderWidth = 1.5
            layer.borderColor = color.cgColor
            clipsToBounds = true
        }
}
