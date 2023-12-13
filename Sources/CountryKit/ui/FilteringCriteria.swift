//
//  FilteringCriteria.swift
//  CountryKit
//
//  Created by eclypse on 12/12/23.
//

import Foundation

/// determines how the search text should be used in the CountryPicker UI
public enum FilteringCriteria: Int {
    /// search text components that are separated by space are treated as "OR".
    case orSearch
    
    /// search text components that are separated by space are treated as "AND".
    case andSearch
}
