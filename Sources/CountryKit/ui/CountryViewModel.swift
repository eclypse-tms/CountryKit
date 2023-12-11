//
//  CountrySelectionViewModel.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation

public struct CountryViewModel: Hashable {
    let country: Country
    let highlightedText: NSAttributedString?
    
    init(country: Country,
         highlightedText: NSAttributedString? = nil) {
        self.country = country
        self.highlightedText = highlightedText
    }
}
