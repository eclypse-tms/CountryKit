//
//  FlagKit+Extensions.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import FlagKit
import UIKit

extension Country {
    public var flagImage: UIImage? {
        return Flag.rectImage(with: self)
    }
}
