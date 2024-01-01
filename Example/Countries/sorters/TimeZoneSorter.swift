//
//  TimeZoneSorter.swift
//  Countries
//
//  Created by eclypse on 12/30/23.
//

import Foundation
import CountryKit

/// sorts countries from east to west depending on the most-eastern border timezone of each country
class TimeZoneSorter: CountrySorter {
    func sort(lhs: Country, rhs: Country) -> Bool {
        if let lhsTimeZone = lhs.wiki.timeZoneOffsets.first, let rhsTimeZone = rhs.wiki.timeZoneOffsets.first {
            return lhsTimeZone < rhsTimeZone
        } else if lhs.wiki.timeZoneOffsets.first != nil {
            //order the lhs first since rhs doesn't have a timezone
            return true
        } else if rhs.wiki.timeZoneOffsets.first != nil {
            //order the rhs first since lhs doesn't have a timezone
            return false
        } else {
            //neither rhs nor lhs have a timezone
            return false
        }
    }
}
