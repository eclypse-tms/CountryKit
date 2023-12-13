//
//  FlagKit+Extensions.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import FlagKit
import UIKit

extension UIImage {
    /**
     Returns a styled flag according to the provided style
     - parameter style: Desired flag style
     */
    
    func roundCorners(accordingTo style: FlagStyle) -> UIImage? {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        defer {
            // End context after returning to avoid memory leak
            UIGraphicsEndImageContext()
        }
        
        switch style {
        case .none:
            break
        case .roundedRect:
            UIBezierPath(roundedRect: rect, cornerRadius: 6).addClip()
        case .square:
            UIBezierPath(rect: rect).addClip()
        case .circle:
            UIBezierPath(roundedRect: rect, cornerRadius: style.size.width).addClip()
        }

        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
