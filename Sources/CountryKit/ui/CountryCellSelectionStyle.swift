//
//  CountryCellSelectionStyle.swift
//  CountryKit
//
//  Created by eclypse on 12/12/23.
//

import Foundation

/// indicates how the cells should be selected
public enum CountryCellSelectionStyle: Int {
    
    /// when the user taps/clicks on a cell, a checkmark appears on the trailing side of the cell
    case checkMark
    
    /// when the user taps/clicks on a cell, entire cell is highlighted
    case highlight
}
