//
//  FlagKit+Extensions.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import FlagKit
import UIKit

extension Flag {
    class func rectImage(with country: Country) -> UIImage {
        if let specialCountryFlag = handleExceptions(alpha2Code: country.alpha2Code, flagStyle: .roundedRect) {
            return specialCountryFlag
        } else {
            let countryFlag = Flag(countryCode: country.alpha2Code)
            return countryFlag?.image(style: .roundedRect) ?? UIImage()
        }
    }
    
    class func rectImage(with alpha2Code: String) -> UIImage? {
        if let specialCountryFlag = handleExceptions(alpha2Code: alpha2Code, flagStyle: .roundedRect) {
            return specialCountryFlag
        } else {
            let countryFlag = Flag(countryCode: alpha2Code)
            return countryFlag?.image(style: .roundedRect)
        }
    }
    
    class func roundImage(with country: Country) -> UIImage? {
        if let specialCountryFlag = handleExceptions(alpha2Code: country.alpha2Code, flagStyle: .circle) {
            return specialCountryFlag
        } else {
            let countryFlag = Flag(countryCode: country.alpha2Code)
            return countryFlag?.image(style: .circle)
        }
    }
    
    class func roundImage(with alpha2Code: String) -> UIImage? {
        if let specialCountryFlag = handleExceptions(alpha2Code: alpha2Code, flagStyle: .circle) {
            return specialCountryFlag
        } else {
            let countryFlag = Flag(countryCode: alpha2Code)
            return countryFlag?.image(style: .circle)
        }
    }
    
    private class func handleExceptions(alpha2Code: String, flagStyle: FlagStyle) -> UIImage? {
        switch alpha2Code.uppercased() {
        case Country.Worldwide.alpha2Code:
            return UIImage(named: "icon_worldwide", in: CountryKit.assetBundle, compatibleWith: nil)
        case "AC": //Ascension Island
            //Ascension island is constituent part of Saint Helena, Ascension and Tristan da Cunha
            //therefore, it uses the Saint Helena's flag (main island)
            return Flag(countryCode: "SH")?.image(style: flagStyle)
        case "BQ": //Bonaire, Sint Eustatius and Saba (a.k.a. Caribbean Netherlands)
            //They consist of the islands of Bonaire, Sint Eustatius and Saba.
            //although the term "Caribbean Netherlands" is sometimes used to refer to all
            //of the islands in the Dutch Caribbean.
            //we are going to use the Bonaire flag to represent all 3 islands
            return UIImage(named: "flag_bonaire", in: CountryKit.assetBundle, compatibleWith: nil)?.convertToFlagImage2(style: flagStyle)
        case "EH": //Western Sahara
            //According to Wikipedia, both Morocco and Sahrawi Arab Democratic Republic (SADR) claim ownership of Western Sahara
            //Since it is a disputed region, a custom flag is used to represent dual ownership of the area
            return UIImage(named: "flag_western_sahara", in: CountryKit.assetBundle, with: nil)?.convertToFlagImage2(style: flagStyle)
        case "TA": //Tristan de Cunha
            //Tristan de Cunha is constituent part of Saint Helena, Ascension and Tristan da Cunha
            //therefore, it uses the Saint Helena's flag (main island)
            return Flag(countryCode: "SH")?.image(style: flagStyle)
        case "AQ": //Antartica
            return UIImage(named: "flag_antartica", in: CountryKit.assetBundle, compatibleWith: nil)?.convertToFlagImage2(style: flagStyle)
        case "001": //Worldwide
            return UIImage(named: "icon_worldwide", in: CountryKit.assetBundle, compatibleWith: nil)?.convertToFlagImage2(style: flagStyle)
        case "150": //Europe
            return UIImage(named: "flag_europe", in: CountryKit.assetBundle, compatibleWith: nil)?.convertToFlagImage2(style: flagStyle)
        case "003": //North America
            return Flag(countryCode: "US")?.image(style: flagStyle)
        case "419", "EA": //Latin America
            return Flag(countryCode: "ES")?.image(style: flagStyle)
        case "IC": // Canary Islands
            return UIImage(named: "flag_canary_islands", in: CountryKit.assetBundle, compatibleWith: nil)?.convertToFlagImage2(style: flagStyle)
        case "DG": //Diego Garcia - British Indian Ocean Territory
            return Flag(countryCode: "IO")?.image(style: flagStyle)
        default:
            return nil
        }
    }
}

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
    
    func convertToFlagImage2(style: FlagStyle) -> UIImage {
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
            UIBezierPath(roundedRect: rect, cornerRadius: 2).addClip()
        case .square:
            UIBezierPath(rect: rect).addClip()
        case .circle:
            UIBezierPath(roundedRect: rect, cornerRadius: style.size.width).addClip()
        }

        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

extension Country {
    public var flagImage: UIImage {
        return Flag.rectImage(with: self)
    }
}
