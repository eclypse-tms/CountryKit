//
//  CountrySelectionViewModel.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation

struct CountrySelectionViewModel: Hashable {
    let country: Country
    var isSelected: Bool
    let shouldShowCellSeparator: Bool
    let highlightedText: NSAttributedString
    let allowsSelection: Bool
    
    /// when this flag is true, clicking on the country will be treated as an intent to display
    /// bulk country selection.
    let interpretSelectionAsIntentToModify: Bool
    let userInteractionStatus: UserInteractionStatus
    
    init(country: Country,
         isSelected: Bool = false,
         allowsSelection: Bool = true,
         shouldShowCellSeparator: Bool = false,
         highlightedText: NSAttributedString? = nil,
         interpretSelectionAsIntentToModify: Bool = false,
         userInteractionStatus: UserInteractionStatus = .interactionEnabled) {
        self.country = country
        self.isSelected = isSelected
        self.shouldShowCellSeparator = shouldShowCellSeparator
        self.highlightedText = highlightedText ?? NSAttributedString(string: country.localizedName)
        self.allowsSelection = allowsSelection
        self.interpretSelectionAsIntentToModify = interpretSelectionAsIntentToModify
        self.userInteractionStatus = userInteractionStatus
    }
}
