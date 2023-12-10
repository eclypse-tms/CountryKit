//
//  AddressLabel.swift
//  
//
//  Created by Turker Nessa on 12/8/23.
//

import Foundation

/// Address Label is used to localize different address components. While addresses in the UK
/// uses town or township label, the addresses in the US uses city label for the same address
/// component.
enum AddressLabel: String, Hashable, Codable {
    ///address line 1 - street level
    case street1
     
    ///address line 2 - street level, or other arbitrary information
    case street2
    
    ///suburb - neighborhood level
    case suburb
    
    ///neighborhood - neighborhood level
    case neighborhood
    
    ///area - neighborhood level
    case area
    
    ///city - city level
    case city
    
    ///township - city level
    case township
    
    ///town - city level
    case town
    
    ///island - district level
    case island
    
    //TODO: investigate whether postal district refers to county level or subcity level region
    ///postal district - district level
    case postalDistrict
    
    ///district - district level
    case district
    
    ///county - district level
    case county
    
    ///state - province level
    case state
    
    ///province - province level
    case province
    
    ///department - province level
    case department
    
    ///prefecture - province level
    case prefecture
    
    ///governorate - province level
    case governorate
    
    ///region - province level
    case region
    
    ///subject of federation - province level
    case subjectOfFederation
    
    ///postal code
    case postalCode
    
    ///zip code
    case zipCode
    
    ///country or territory - country level
    case country
    
    ///an arbitrary integer value that indicates the relative geographic size of each field.
    ///smaller values indicate an address field with smaller geographic span.
    var geographicSize: Int {
        switch self {
        case .street1: return 1
        case .street2: return 1
        case .suburb: return 10
        case .area: return 10
        case .neighborhood: return 10
        case .postalCode: return 50
        case .zipCode: return 50
        case .city: return 100
        case .town: return 100
        case .township: return 100
        case .county: return 200
        case .island: return 200
        case .district: return 200
        case .postalDistrict: return 200
        case .state: return 500
        case .province: return 500
        case .prefecture: return 500
        case .department: return 500
        case .subjectOfFederation: return 500
        case .region: return 500
        case .governorate: return 500
        case .country: return 1000
        }
    }
    
    /// indicates the component this label belongs to.
    /// @see AddressComponent
    var addressComponent: AddressComponent {
        switch self {
        case .street1, .street2:
            return .street
        case .suburb, .neighborhood, .area:
            return .subLocality
        case .city, .township, .town:
            return .city
        case .island, .postalDistrict, .district, .county:
            return .subAdministrativeArea
        case .state, .province, .department, .prefecture, .governorate, .region, .subjectOfFederation:
            return .stateOrProvince
        case .postalCode, .zipCode:
            return .postalOrZipCode
        case .country:
            return .country
        }
    }
    
    ///list of fields to use when which fields are not known
    static var defaultList: [AddressLabel] {
        return [.street1, .street2, .city, .province, .postalCode]
    }
    
    static var cityOnly: [AddressLabel] {
        return [.street1, .street2, .city]
    }
    
    static var cityAndPostal: [AddressLabel] {
        return [.street1, .street2, .city, .postalCode]
    }
    
    /// address style used in
    static var usStyle: [AddressLabel] {
        return [.street1, .street2, .city, .state, .zipCode]
    }
}
