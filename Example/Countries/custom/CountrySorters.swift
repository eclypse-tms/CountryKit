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
        
        let isLhsNACountry = lhs == .Canada || lhs == .United_States || lhs == .Mexico
        let isRhsNACountry = rhs == .Canada || rhs == .United_States || rhs == .Mexico
        
        
        if isLhsNACountry, !isRhsNACountry {
            //left hand side is NA country but right hand side is not
            //return true to order lhs before rhs
            return true
        } else if !isLhsNACountry, isRhsNACountry {
            //right hand side is NA country but left hand side is not
            //return false to order rhs before lhs
            return false
        } else if isLhsNACountry, isRhsNACountry {
            //simply apply localized name comparison
            return false
        } else {
            //simply apply localized name comparison for all other countries
            return _compare(lhs: lhs, rhs: rhs)
        }
    }
}
