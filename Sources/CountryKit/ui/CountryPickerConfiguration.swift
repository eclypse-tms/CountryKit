//
//  CountryPickerConfiguration.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import UIKit

/// an object that allows the picker UI to be customizable.
public struct CountryPickerConfiguration {
    /// controls whether the country selection interface allows user to select a country.
    public var allowsSelection: Bool = true
    
    /// controls whether the country selection interface allows user to select multiple countries.
    public var canMultiSelect: Bool = true
    
    /// restrict the countries to the ones in this list. leave empty to show all the countries.
    public var countryRoster: Set<Country> = Set()
    
    /// if the countries are restricted to a limited set, you may
    /// provide justification to the user as to why that is the case. optional.
    public var rosterJustification: String = ""
    
    /// list of countries that should be excluded from the main list.
    /// if countryRoster is provided, this property is ignored.
    public var excludedCountries: Set<Country> = Set()
    
    /// if some countries are removed the list, you may provide justification
    /// to the user as to why that is the case. optional.
    public var excludedCountriesJustification: String = ""
    
    /// after the user makes the first selection, automatically dismisses
    /// the interface. defaults to false.
    public var dismissAfterFirstSelection: Bool = false
    
    /// the countries on this list are preselected when the UI first opens
    public var preselectedCountries: Set<Country> = Set()
    
    /// allow user to select worldwide as an addition option.
    /// worldwide represents a selection of all countries and regions.
    public var shouldShowWorldWide: Bool = false
    
    /// only needed if your are planning to display worldwide as a selectable option.
    /// for example, in english this property would read "Worlwide".
    public var localizedWorldWide: String = ""

    /// only needed if your are planning to display worldwide as a selectable option.
    /// for example, in english this property would read something like 
    /// "Selecting Worldwide clears previous country selections and represents a
    /// selection of all countries and regions."
    public var localizedWorldWideDescription: String = ""
    
    /// provide custom bar button that appears on the left (leading) side of the 
    /// navigation bar instead of chevron.backward styled back bar button.
    /// if you provide a custom button, you are responsible for dismissing the picker view yourself.
    /// if this button is provided, buttonDisplayOption is ignored
    public var leftBarButton: UIBarButtonItem?

    /// provide custom bar button item that appears on the right (trailing) side of the
    /// navigation bar instead of system Done button.
    /// if you provide a custom button, you are responsible for dismissing the picker view yourself.
    /// if this button is provided, buttonDisplayOption is ignored
    public var rightBarButton: UIBarButtonItem?
    
    /// when provided, a header text is displayed that is pinned to the top 
    /// of the picker view and does not scroll away.
    public var pinnedHeaderText: String?
    
    /// when provided, a footer text is displayed that is pinned to the bottom 
    /// of the picker view and does not scroll away.
    public var pinnedFooterText: String?
    
    /// the methodology to use when filtering countries
    public var searchMethodology: SearchMethodology = .orSearch
    
    /// controls whether to display both the cancel and done buttons in the UI
    public var buttonDisplayOption: ToolbarButtonsDisplayOption = .displayBothButtons
    
    /// controls which countries, regions or territories to display in the PickerUI. 
    /// By default, it includes all territories that have an alpha 2 code assigned to it.
    /// If a country roster is provided, this property is ignored.
    public var countryListOption: CountryListOption = .all
    
    /// you can provide your own custom sorting algorithm for the picker view.
    public var countrySorter: CountrySorter?
    
    /// if you are presenting the picker view in a window that already includes a search bar,
    /// turn this flag to false to hide the embedded search bar.
    public var showSearchBar: Bool = true
    
    /// additional configuration parameters when running the picker view in mac catalyst mode
    public var macConfiguration: MacConfiguration = .default()
    
    /// theme to apply to the picker view
    public var theme: CountryPickerTheme = .default()
    
    /// initializes CountrySelectionConfiguration with default parameters
    static public func `default`() -> CountryPickerConfiguration {
        CountryPickerConfiguration()
    }
    
    /// initializes CountrySelectionConfiguration with default parameters
    public init() {}
}
