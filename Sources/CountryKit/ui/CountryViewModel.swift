//
//  CountrySelectionViewModel.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation

public struct CountryViewModel: Hashable {
    /// underlying country
    public let country: Country
    
    /// optional search text that is highlighted
    public let highlightedSearchText: NSAttributedString?
    
    init(country: Country,
         highlightedText: NSAttributedString? = nil) {
        self.country = country
        self.highlightedSearchText = highlightedText
    }
}
