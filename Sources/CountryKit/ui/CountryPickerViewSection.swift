//
//  CountryPickerViewSection.swift
//  CountryKit
//
//  Created by eclypse on 12/8/23.
//

import Foundation

/// sections for the country picker ui
enum CountryPickerViewSection: Int, CaseIterable {
    
    /// worldwide row - if enabled
    case worldwide
    
    /// worldwide explanation - if enabled
    case worldwideExplanation
    
    /// list of all countries
    case allCountries
    
    /// if country list is limited, additional explanation as to why it is limited
    case rosterExplanation
}
