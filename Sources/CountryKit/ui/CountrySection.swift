//
//  CountrySection.swift
//  CountryKit
//
//  Created by eclypse on 12/8/23.
//

import Foundation

enum CountrySection: Int {
    case worldWide
    case allCountries
    
    var cellIdentifier: String {
        switch self {
        case .allCountries, .worldWide:
            return "CountryCell"
        }
    }
}
