//
//  Alpha2Sorter.swift
//  Countries
//
//  Created by Turker Nessa Kucuk on 12/29/23.
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

/// sorts countries by area in descending order
class AreaSorter: CountrySorter {
    func sort(lhs: Country, rhs: Country) -> Bool {
        return lhs.wiki.area > rhs.wiki.area
    }
}

/// displays the countries in north america first and then displays the countries by their name
class CountriesInNorthAmericaFirst: CountrySorter {
    func sort(lhs: Country, rhs: Country) -> Bool {
        func _compare(lhs: Country, rhs: Country) -> Bool {
            let result = lhs.localizedName.compare(rhs.localizedName, options: [.caseInsensitive, .diacriticInsensitive])
            switch result {
            case .orderedAscending:
                return true
            default:
                return false
            }
        }
        
        
        if lhs == .Canada || lhs == .United_States || lhs == .Mexico {
            return _compare(lhs: lhs, rhs: rhs)
        } else {
            return _compare(lhs: lhs, rhs: rhs)
        }
    }
}
