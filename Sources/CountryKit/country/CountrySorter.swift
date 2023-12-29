//
//  CountrySorter.swift
//
//
//  Created by Turker Nessa Kucuk on 12/29/23.
//

import Foundation

/// determines how a list of countries should be sorted
public protocol CountrySorter: AnyObject {
    /// same as the default implementation. sorts countries by their localized name.
    func sort(lhs: Country, rhs: Country) -> Bool
}

public class CountrySorterImpl: CountrySorter {
    public func sort(lhs: Country, rhs: Country) -> Bool {
        //same as the default implementation
        let result = lhs.localizedName.compare(rhs.localizedName, options: [.caseInsensitive, .diacriticInsensitive])
        switch result {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
}
