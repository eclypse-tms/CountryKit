//
//  Alpha2Sorter.swift
//  Countries
//
//  Created by eclypse on 12/30/23.
//

import Foundation
import CountryKit

/// sorts countries by their alpha2 code
class Alpha2Sorter: CountrySorter {
    func sort(lhs: Country, rhs: Country) -> Bool {
        let result = lhs.alpha2Code.compare(rhs.alpha2Code, options: [.caseInsensitive])
        switch result {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
}
