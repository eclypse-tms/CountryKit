//
//  CountrySelectionConfiguration.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation

public struct CountrySelectionConfiguration: Hashable {
    /// controls whether country selection interface allows user to select a country
    public var allowsSelection: Bool = true
    
    /// controls whether country selection interface allows user to select multiple countries
    public var canMultiSelect: Bool = true
    
    /// controls whether country selection interface allows user to highlight the row without actually making a selection
    /// this option is only considered if allowsSelection is false.
    public var canHighlightWithoutSelecting: Bool = false
    
    ///should worldwide be a visible option
    public var shouldShowWorldWide: Bool = true
    
    ///restrict the countries to the ones in this list. leave empty to show all the countries
    public var countryRoster: Set<Country> = Set()
    
    ///if the countries are restricted to a limited set, you provide justification to the user as to why that is the case
    public var rosterJustification: String = ""
    
    /// list of countries that should be excluded from the main list.
    /// if countryRoster is provided, this property is ignored.
    public var excludedCountries: Set<Country> = Set()
    
    ///if some countries are removed the list, you may provide justification to the user as to why that is the case
    public var excludedCountriesJustification: String = ""
    
    ///after the user makes the first selection, automatically dismisses the interface. defaults to false.
    public var autoDismiss: Bool = false
    
    /// the countries on this list are preselected when the UI first opens
    public var previouslySelectedCountries: [Country] = [Country]()
    
    /// if your app supports multiple languages, then provide "worldwide" in your target language. defaults to english.
    /// only needed if your are planning to display worldwide as a selectable option.
    public var localizedWorldWide: String = "country_worldwide".localize()

    /// if your app supports multiple languages, then provide a description in your target language. defaults to english.
    /// only needed if your are planning to display worldwide as a selectable option.
    public var localizedWorldWideDescription: String = "info_about_worldwide_selection".localize()
    
    
    static public var `default`: CountrySelectionConfiguration = CountrySelectionConfiguration()
}
