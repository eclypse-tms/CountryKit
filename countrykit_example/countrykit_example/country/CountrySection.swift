//
//  CountrySection.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/8/23.
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
