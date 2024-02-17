//
//  UIView+Extensions.swift
//
//
//  Created by eclypse on 2/17/24.
//

import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat) {
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
