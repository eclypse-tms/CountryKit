//
//  SingleCountrySelectionDelegate.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation

protocol SingleCountrySelectionDelegate: AnyObject {
    func didSelect(country: Country)
    func didDeselect(country: Country)
    func didClickToOpenBulkCountrySelection()
}

extension SingleCountrySelectionDelegate {
    //make it optional
    func didClickToOpenBulkCountrySelection() {}
}
