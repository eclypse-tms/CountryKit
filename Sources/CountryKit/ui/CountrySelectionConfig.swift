//
//  CountrySelectionConfig.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation

public struct CountrySelectionConfig: Hashable {
    
    ///does country selection interface allows user to select multiple countries
    let canMultiSelect: Bool
    
    ///should worldwide be a visible option
    let shouldShowWorldWide: Bool
    
    ///restrict the countries to the ones in this list. leave empty to show all the countries
    let countryRoster: Set<Country>
    
    ///if the countries are restricted to a limited set, you provide justification to the user as to why
    ///that is the case
    let rosterJustification: String
    
    ///after the user makes the first selection, automatically dismisses the interface
    let autoDismiss: Bool
    
    /// the countries on this list are preselected when the view first opens
    let previouslySelectedCountries: [Country]
    
    init(canMultiSelect: Bool, shouldShowWorldWide: Bool, countryRoster: Set<Country>,
         rosterJustification: String, autoDismiss: Bool, previouslySelectedCountries: [Country]) {
        self.canMultiSelect = canMultiSelect
        self.shouldShowWorldWide = shouldShowWorldWide
        self.countryRoster = countryRoster
        self.rosterJustification = rosterJustification
        self.autoDismiss = autoDismiss
        self.previouslySelectedCountries = previouslySelectedCountries
    }
    
    /// initializes a CountrySelectionConfig object with default values and previously selected country list
    init(withOnly previouslySelectedCountries: [Country], shouldShowWorldWide: Bool) {
        self.canMultiSelect = true
        self.shouldShowWorldWide = shouldShowWorldWide
        self.countryRoster = Set()
        self.rosterJustification = ""
        self.autoDismiss = false
        self.previouslySelectedCountries = previouslySelectedCountries
    }
    
    init(countryRoster: Set<Country>, rosterJustification: String, previouslySelectedCountries: [Country],
         shouldShowWorldWide: Bool) {
        self.canMultiSelect = true
        self.shouldShowWorldWide = shouldShowWorldWide
        self.countryRoster = countryRoster
        self.rosterJustification = rosterJustification
        self.autoDismiss = false
        self.previouslySelectedCountries = previouslySelectedCountries
    }
    
    static let defaultValue: CountrySelectionConfig =
        CountrySelectionConfig(canMultiSelect: true,
                               shouldShowWorldWide: true,
                               countryRoster: Set(),
                               rosterJustification: "",
                               autoDismiss: false,
                               previouslySelectedCountries: [])
}
