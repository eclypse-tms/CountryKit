//
//  UIView+RoundedCorner.swift
//  countrykit_example
//
//  Created by eclypse on 12/10/23.
//

import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat) {
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func unroundCorners() {
        self.layer.maskedCorners = []
        self.layer.cornerRadius = CGFloat.zero
        self.clipsToBounds = false
    }
    
    func addBorder(borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func removeBorder() {
        self.layer.borderWidth = CGFloat.zero
        self.layer.borderColor = nil
    }
}
