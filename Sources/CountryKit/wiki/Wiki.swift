//
//  Wiki.swift
//
//
//  Created by eclypse on 12/28/23.
//

import Foundation

public struct Wiki: Hashable, Codable {
    /// A country code top-level domain (ccTLD) is an Internet top-level domain generally used or reserved for a country,
    /// sovereign state, or dependent territory identified with a country code. All ASCII ccTLD identifiers are two letters long,
    /// and all two-letter top-level domains are ccTLDs.
    /// Some regions in this list do not have a top domain. for example: Western Sahara and United States Minor Outlying Islands
    public var topLevelDomain: String?
    
    /// link to the wikipedia page where this information was obtained from
    public var wikipediaLink: URL?
    
    /// official (de-jure) capital city of this country, territory or region. Not all regions have a capital city.
    public var capitalCity: String?
    
    /// some countries or regions may have an alternate capital city in addition to or in-lieu-of due to economic, political or geographical reasons.
    public var capitalCityDeFacto: String?
    
    /// ISO 639-1, ISO 639-2 or ISO 639-3 codes of that country's official languages. Not all countries have declared an official language and some
    /// countries have more than one official languages.
    public var officialLanguages: [String] = []
    
    /// area of the country or region in square kilometers
    public var area: Double
    
    /// the timezone offsets this country or region uses
    public var timeZoneOffsets: [TimeZoneOffset] = []
    
    /// the timezone offsets this country or region uses, if any
    public var daylightSavingsTimeZoneOffsets: [TimeZoneOffset] = []
    
    /// the country code to dial when calling a phone number from another country
    public var internationalCallingCode: String?
    
    /// some countries or regions may share the country code with one and other. This is especially true for many
    /// Caribbean nations. Those countries instead employ an additional area code prefix that differentiate phone
    /// numbers from and other.
    public var dedicatedAreaCodes: [String] = []
    
    /// whether this county belongs Commonwealth of Nations
    public var isMemberOfCommonwealth: Bool
    
    /// alpha2 code of the sovereign nation that manages this country, region or territory's certain affairs on behalf of it.
    /// For example Finland is the sovereign state of Åland Islands.
    public var sovereignStateCountryCode: String?

    /// indicates whether a permanent population lives here or not. For example Antartica and Bouvet Islands do not
    /// have a permanent population.
    public var territoryWithoutAnyPermanentPopulation: Bool
    
    /// indicates whether this territory, region or country is disputed and its existence is not officially recognized universally by
    /// majority of other countries. For example Western Sahara is  disputed territory where it is both claimed by Morocco and
    /// Sahrawi Arab Democratic Republic.
    public var disputedTerritory: Bool
    
    /// not available to public
    static func uninitializedWiki() -> Wiki {
        return Wiki(topLevelDomain: nil,
                    wikipediaLink: nil,
                    capitalCity: nil,
                    capitalCityDeFacto: nil,
                    officialLanguages: [],
                    area: Double.zero,
                    timeZoneOffsets: [],
                    daylightSavingsTimeZoneOffsets: [],
                    internationalCallingCode: nil,
                    dedicatedAreaCodes: [],
                    isMemberOfCommonwealth: false,
                    sovereignStateCountryCode: nil,
                    territoryWithoutAnyPermanentPopulation: false,
                    disputedTerritory: false)
    }
}
