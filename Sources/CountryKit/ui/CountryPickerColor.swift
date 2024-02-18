//
//  CountryPickerColor.swift
//
//
//  Created by CountryPickerColor on 2/17/24.
//

import UIKit

/// list of colors that are used by the picker view
public struct CountryPickerColor {
    
    /// the default tint that is applied when a cell/row is selected.
    public static let defaultHighlight: UIColor = UIColor(dynamicProvider: { traitInfo in
        switch traitInfo.userInterfaceStyle {
        case .dark:
            return UIColor.systemGray6
        case .light:
            return UIColor.systemGray4
        default:
            return UIColor.systemGray4
        }
    })
}
