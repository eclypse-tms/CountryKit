//
//  UIColor+Extensions.swift
//
//
//  Created by eclypse on 1/4/24.
//

import UIKit

extension UIColor {
    /// indicates whether this color is perceived as a bright color to human eyes
    /// see http://alienryderflex.com/hsp.html
    var isPerceivedBright: Bool {
        var redComponent: CGFloat = .zero
        var greenComponent: CGFloat = .zero
        var blueComponent: CGFloat = .zero
         
        let successs = self.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: nil)
        
        if successs {
            if redComponent > 1.0 {
                redComponent = 1.0
            }
            
            if greenComponent > 1.0 {
                greenComponent = 1.0
            }
            
            if blueComponent > 1.0 {
                blueComponent = 1.0
            }
            
            let redNormalized = redComponent * 255.0
            let greenNormalized = greenComponent * 255.0
            let blueNormalized = blueComponent * 255.0
            
            let hspSquared: Double = (0.299 * redNormalized * redNormalized) + (0.587 * greenNormalized * greenNormalized) + (0.114 * blueNormalized * blueNormalized)
            
            let hsp = sqrt(hspSquared)
            if (hsp > 127.5) {
                return true
            } else {
                return false
            }
        } else {
            //we can determine the brighness of this color
            return false
        }
    }
}
