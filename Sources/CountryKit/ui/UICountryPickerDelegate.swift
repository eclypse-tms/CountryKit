//
//  UICountryPickerDelegate.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation


/// This protocol triggers events when user makes a selection or a deselection in the PickerView UI.
/// All methods in this protocol are optional.
/// If you need immediate callback as soon as user makes a selection, then override didSelect(country:) and didDeselect(country:) methods.
/// If you want to wait for the user to finish making their selections and get notified of all the selections when the pickerview is dismissed, then
/// override didFinishSelecting(countries:) method.
public protocol UICountryPickerDelegate: AnyObject {
    /// This event fires when user selects a country. Optional.
    /// - Parameter country: The country object that was selected
    func didSelect(country: Country)
    
    /// This event fires when user reverses a previous country selection. Optional.
    /// - Parameter country: The country object that was deselected
    func didDeselect(country: Country)
    
    /// List of all countries user has selected at the end of their interaction with UICountryPicker. Optional.
    /// This event is fired when the view controller is being dismissed.
    /// - Parameter countries: List of all countries user has selected
    func didFinishSelecting(countries: [Country])
    
    /// User clicked back/cancel to return to previous screen. Optional.
    func didCancel()
}

public extension UICountryPickerDelegate {
    func didSelect(country: Country) {}
    func didDeselect(country: Country) {}
    func didFinishSelecting(countries: [Country]) {}
    func didCancel() {}
}
