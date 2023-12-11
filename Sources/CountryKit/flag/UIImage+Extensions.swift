//
//  FlagKit+Extensions.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import FlagKit
import UIKit

extension UIImage {
    func drawnImage(size outputSize: CGSize, action: (UIGraphicsImageRendererContext) -> Void) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: outputSize, format: format)
        return renderer.image(actions: { (context) in
            action(context)
            
            // Draw image centered in the renderer
            let bounds = context.format.bounds
            let rect = CGRect(x: (bounds.size.width - size.width)/2, y: (bounds.size.height - size.height)/2, width: size.width, height: size.height)
            self.draw(in: rect)
        })
    }
    
    /**
     Returns a styled flag according to the provided style
     - parameter style: Desired flag style
     */
    func convertToFlagImage(style: FlagStyle) -> UIImage {
        return drawnImage(size: style.size, action: { (context) in
            switch style {
            case .none:
                break
            case .roundedRect:
                let path = UIBezierPath(roundedRect: context.format.bounds, cornerRadius: 2)
                path.addClip()
            case .square:
                let path = UIBezierPath(rect: context.format.bounds)
                path.addClip()
            case .circle:
                let path = UIBezierPath(roundedRect: context.format.bounds, cornerRadius: style.size.width)
                path.addClip()
            }
        })
    }
    
    func convertToFlagImage2(style: FlagStyle) -> UIImage? {
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
