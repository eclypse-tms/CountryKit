//
//  AreaSorter.swift
//  Countries
//
//  Created by eclypse on 12/30/23.
//

import Foundation
import CountryKit

/// sorts countries by area in descending order
class AreaSorter: CountrySorter {
    func sort(lhs: Country, rhs: Country) -> Bool {
        return lhs.wiki.area > rhs.wiki.area
    }
}
