//
//  CountryPickerViewSection.swift
//  CountryKit
//
//  Created by eclypse on 12/8/23.
//

import UIKit
import Composure

/// sections for the country picker ui
enum CountryPickerViewSection: Int, CaseIterable, DefinesCompositionalLayout {
    /// worldwide row - if enabled
    case worldwide
    
    /// worldwide explanation - if enabled
    case worldwideExplanation
    
    /// list of all countries
    case allCountries
    
    /// if country list is limited, additional explanation as to why it is limited
    case rosterExplanation
    
    func layoutInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> Composure.CompositionalLayoutOption {
        switch self {
        case .worldwide, .allCountries:
            if designedForMac {
                return .fullWidthFixedHeight(fixedHeight: CountryPickerPresenter.universalConfig.macConfiguration.rowHeight)
            } else {
                return .fullWidthFixedHeight(fixedHeight: UIFloat(44))
            }
        case .worldwideExplanation, .rosterExplanation:
            return .fullWidthDynamicHeight(estimatedHeight: UIFloat(44))
        }
    }
}
