//
//  CellSelectionMeta.swift
//  CountryKit
//
//  Created by eclypse on 12/10/23.
//

import Foundation

struct CellSelectionMeta: Hashable {
    /// indicates the country that the user interacted with
    let country: Country
    
    /// whether this country is selected or deselected
    let isSelected: Bool
    
    /// indexPath of this country in the table view
    let indexPath: IndexPath
    
    /// indicates whether table view should perform a programmatic cell selection
    let performCellSelection: Bool
    
    /// whether this cell selection happened by user action or programmatically to restore views
    let isInitiatedByUser: Bool
    
    init(country: Country, isSelected: Bool, indexPath: IndexPath, performCellSelection: Bool = false, isInitiatedByUser: Bool) {
        self.country = country
        self.isSelected = isSelected
        self.indexPath = indexPath
        self.performCellSelection = performCellSelection
        self.isInitiatedByUser = isInitiatedByUser
    }
}
