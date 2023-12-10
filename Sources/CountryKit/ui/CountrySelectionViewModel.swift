//
//  CountrySelectionViewModel.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation

struct CountrySelectionViewModel: Hashable {
    let country: Country
    let highlightedText: NSAttributedString?
    
    init(country: Country,
         highlightedText: NSAttributedString? = nil) {
        self.country = country
        self.highlightedText = highlightedText
    }
}
