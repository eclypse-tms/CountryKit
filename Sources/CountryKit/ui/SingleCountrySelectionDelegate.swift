//
//  SingleCountrySelectionDelegate.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation


/// Conform to this protocol if you want to be notified every time user makes a selection or
/// a deselection in the UI. The events in this protocol trigger right away after a selection
/// is made.
protocol SingleCountrySelectionDelegate: AnyObject {
    /// This event fires when user selects a country
    /// - Parameter country: The country object that was selected
    func didSelect(country: Country)
    
    /// This event fires when user reverses a previous country selection
    /// - Parameter country: The country object that was deselected
    func didDeselect(country: Country)
}


/// Conform to this protocol if you want to be notified when the user is finished with making
/// their country selections. The event in this protocol trigger when the country selection
/// view controller is dismissed.
protocol BulkCountrySelectionDelegate: AnyObject {
    /// List of all countries user has selected at the end of their interaction with CountryKit UI
    /// - Parameter countries: List of all countries user has selected
    func didFinishSelecting(countries: [Country])
}
