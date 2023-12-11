//
//  CountrySelectionConfig.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation

public struct CountrySelectionConfig: Hashable {
    
    ///does country selection interface allows user to select multiple countries
    var canMultiSelect: Bool = true
    
    ///should worldwide be a visible option
    var shouldShowWorldWide: Bool = false
    
    ///restrict the countries to the ones in this list. leave empty to show all the countries
    var countryRoster: Set<Country> = Set()
    
    ///if the countries are restricted to a limited set, you provide justification to the user as to why
    ///that is the case
    var rosterJustification: String = ""
    
    ///after the user makes the first selection, automatically dismisses the interface. defaults to false.
    var autoDismiss: Bool = false
    
    /// the countries on this list are preselected when the UI first opens
    var previouslySelectedCountries: [Country] = [Country]()
    
    /// if your app supports multiple languages, then provide "worldwide" in your target language. defaults to english.
    /// only needed if your are planning to display worldwide as a selectable option.
    var localizedWorldWide: String = "country_worldwide".localize()

    /// if your app supports multiple languages, then provide a description in your target language. defaults to english.
    /// only needed if your are planning to display worldwide as a selectable option.
    var localizedWorldWideDescription: String = "info_about_worldwide_selection".localize()
    
    
    static var `default`: CountrySelectionConfig =
        CountrySelectionConfig(canMultiSelect: true,
                               shouldShowWorldWide: true,
                               countryRoster: Set(),
                               rosterJustification: "",
                               autoDismiss: false,
                               previouslySelectedCountries: [])
}
