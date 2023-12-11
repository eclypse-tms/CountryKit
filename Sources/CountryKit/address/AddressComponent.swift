//
//  AddressComponent.swift
//  
//
//  Created by Turker Nessa on 12/8/23.
//

import Foundation

/// AddressComponent is modeled after Apple's CNPostalAddress. Each locale uses
/// a different combination of address labels to make up a complete postal address,
/// Apple's library maps different components of a postal address to one of the below cases.
/// For example, a postal address that has neighborhood information may map to sublocality,
/// whereas, a province may map to state.
public enum AddressComponent: String, Hashable {
    /// combination of address line 1 & address line 2 and separated by “\n”
    case street
     
    /// additional information associated with the location, typically defined at the city or town level, in a postal address.
    case subLocality
    
    /// city
    case city
    
    /// the subadministrative area (such as a county or other region) in a postal address.
    case subAdministrativeArea
    
    /// the province or the state information in a postal address
    case stateOrProvince
    
    ///The postal or zip code in a postal address.
    case postalOrZipCode
    
    ///The country name for this postal address.
    case country
    
    ///The ISO country code for the country in a postal address, using the ISO 3166-1 alpha-2 standard.
    case isoCountryCode
    
    public var specificLabels: [AddressLabel] {
        switch self {
        case .street:
            return [.street1, .street2]
        case .subLocality:
            return [.neighborhood, .suburb, .area]
        case .city:
            return [.city, .town, .township]
        case .subAdministrativeArea:
            return [.county, .district, .postalDistrict, .island]
        case .stateOrProvince:
            return [.state, .province, .department, .prefecture, .governorate, .region, .subjectOfFederation]
        case .postalOrZipCode:
            return [.zipCode, .postalCode]
        case .country:
            return [.country]
        case .isoCountryCode:
            return [.country]
        }
    }
}
