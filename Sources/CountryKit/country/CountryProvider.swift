//
//  CountryProvider.swift
//  
//
//  Created by eclypse on 12/8/23.
//

import Foundation


public protocol CountryProvider: AnyObject {
    /// a dictionary of all known countries keyed by each countries alpha2 code
    var allKnownCountries: [String: Country] { get }
    
    /// get a country for a given Locale
    func find(by locale: Locale) -> Country
    
    /// get a country for a given ISO 3166-1 alpha 2 code
    func find(alpha2Code: String) -> Country
    
    /// get a country for a given ISO 3166-1 alpha 3 code
    func find(alpha3Code: String) -> Country
    
    /// loads all metadata about countries into memory.
    /// You should call this function only once per app's lifecycle preferably in a non-main thread.
    func loadAdditionalMetaData()
}

open class CountryProviderImpl: CountryProvider {
    open var bundleLoader: CountryKitBundleLoader
    
    /// default initializer. there is generally no need to initialize the CountryProvider any other way
    public init() {
        self.bundleLoader = CountryKitBundleLoaderImpl()
    }
    
    /// only use this initializer if you need specific behaviors from the filemanager or the bundle
    public init(bundleLoader: CountryKitBundleLoader) {
        self.bundleLoader = bundleLoader
    }
    
    public func loadAdditionalMetaData() {
        loadAssociatedLocales()
        loadWikiData()
    }
    
    private func loadWikiData() {
        guard let fileContents = bundleLoader.getFileContents(fileName: "Wiki", fileExtension: "csv", encoding: nil) else { return }
        //this is a csv file
        let parsedLocaleList = fileContents.components(separatedBy: CharacterSet.newlines)
        for (index, eachParsedLocaleList) in parsedLocaleList.enumerated() {
            if index == 0 {
                //skip the header row
                continue
            }
            
            let components = eachParsedLocaleList.components(separatedBy: ",")
            if components.count == 19 {
                //0:rownum -> reference purposes only
                //1:alpha2 code
                //2:country name -> reference purposes only
                //3:top level domain
                //4:wikipedia link
                //5:de-jure capital city
                //6:de-facto capital city,
                //7:official languages -> reference purposes only
                //8:language ISO 639 codes
                //9:area (in km2),
                //10:time zones
                //11:day light saving time zones,
                //12:international calling code
                //13:dedicated area codes
                //14:is country Commonwealth?
                //15:sovereign state name -> reference purposes only
                //16:sovereign state alpha 2 code
                //17:is territory only (no permanent population)
                //18:disputed territory
                let wiki = Wiki(
                    topLevelDomain: components[3].valueOrNil,
                    wikipediaLink: URL(string: components[4]),
                    capitalCity: components[5].valueOrNil,
                    capitalCityDeFacto: components[6].valueOrNil,
                    officialLanguages: components[8].components(separatedBy: "|").compactMap { $0.valueOrNil },
                    area: Double(components[9]) ?? .zero,
                    timeZoneOffsets: components[10].components(separatedBy: "|").compactMap { TimeZoneOffset(rawValue: $0) }.sorted(),
                    daylightSavingsTimeZoneOffsets: components[11].components(separatedBy: "|").compactMap { TimeZoneOffset(rawValue: $0) }.sorted(),
                    internationalCallingCode: components[12].valueOrNil,
                    dedicatedAreaCodes: components[13].components(separatedBy: "|").compactMap { $0.valueOrNil },
                    isMemberOfCommonwealth: Bool(components[14].lowercased()) ?? false,
                    alpha2CodeOfItsSovereignState: components[16].valueOrNil,
                    noPermanentPopulation:  Bool(components[17].lowercased()) ?? false,
                    isDisputedTerritory: Bool(components[18].lowercased()) ?? false)
                let alpha2Code = components[1]
                allKnownCountries[alpha2Code]?.wiki = wiki
            } else {
                //we don't know how to parse this enty
                continue
            }
        }
    }
    
    private func loadAssociatedLocales() {
        guard let fileContents = bundleLoader.getFileContents(fileName: "Locales", fileExtension: "csv", encoding: nil) else { return }
        //this is a csv file
        let parsedLocaleList = fileContents.components(separatedBy: CharacterSet.newlines)
        for (index, eachParsedLocaleList) in parsedLocaleList.enumerated() {
            if index == 0 {
                //skip the header row
                continue
            }
            
            let components = eachParsedLocaleList.components(separatedBy: ",")
            if components.count > 2 {
                //locale,regioncode,region,language,script
                let localeIdentifier = components[0]
                let alpha2Code = components[1]
                allKnownCountries[alpha2Code]?.locales.append(Locale(identifier: localeIdentifier))
            } else {
                //this locale entry does not have locale identifier and region code
                continue
            }
        }
    }
    
    /// a dictionary of all known countries that are keyed by their alpha2 code
    lazy public var allKnownCountries: [String: Country] = {
        return [
            Country.United_States.alpha2Code: .United_States,
            Country.Canada.alpha2Code: .Canada,
            Country.Mexico.alpha2Code: .Mexico,
            Country.Afghanistan.alpha2Code: .Afghanistan,
            Country.Aland_Islands.alpha2Code: .Aland_Islands,
            Country.Albania.alpha2Code: .Albania,
            Country.Algeria.alpha2Code: .Algeria,
            Country.American_Samoa.alpha2Code: .American_Samoa,
            Country.Andorra.alpha2Code: .Andorra,
            Country.Angola.alpha2Code: .Angola,
            Country.Anguilla.alpha2Code: .Anguilla,
            Country.Antarctica.alpha2Code: .Antarctica,
            Country.Antigua_and_Barbuda.alpha2Code: .Antigua_and_Barbuda,
            Country.Argentina.alpha2Code: .Argentina,
            Country.Armenia.alpha2Code: .Armenia,
            Country.Aruba.alpha2Code: .Aruba,
            Country.Australia.alpha2Code: .Australia,
            Country.Austria.alpha2Code: .Austria,
            Country.Azerbaijan.alpha2Code: .Azerbaijan,
            Country.Bahamas.alpha2Code: .Bahamas,
            Country.Bahrain.alpha2Code: .Bahrain,
            Country.Bangladesh.alpha2Code: .Bangladesh,
            Country.Barbados.alpha2Code: .Barbados,
            Country.Belarus.alpha2Code: .Belarus,
            Country.Belgium.alpha2Code: .Belgium,
            Country.Belize.alpha2Code: .Belize,
            Country.Benin.alpha2Code: .Benin,
            Country.Bermuda.alpha2Code: .Bermuda,
            Country.Bhutan.alpha2Code: .Bhutan,
            Country.Bolivia.alpha2Code: .Bolivia,
            Country.Bonaire_Sint_Eustatius_and_Saba.alpha2Code: .Bonaire_Sint_Eustatius_and_Saba,
            Country.Bosnia_and_Herzegovina.alpha2Code: .Bosnia_and_Herzegovina,
            Country.Botswana.alpha2Code: .Botswana,
            Country.Bouvet_Island.alpha2Code: .Bouvet_Island,
            Country.Brazil.alpha2Code: .Brazil,
            Country.British_Indian_Ocean_Territory.alpha2Code: .British_Indian_Ocean_Territory,
            Country.Brunei.alpha2Code: .Brunei,
            Country.Bulgaria.alpha2Code: .Bulgaria,
            Country.Burkina_Faso.alpha2Code: .Burkina_Faso,
            Country.Burundi.alpha2Code: .Burundi,
            Country.Cape_Verde.alpha2Code: .Cape_Verde,
            Country.Cambodia.alpha2Code: .Cambodia,
            Country.Cameroon.alpha2Code: .Cameroon,
            Country.Cayman_Islands.alpha2Code: .Cayman_Islands,
            Country.Central_African_Republic.alpha2Code: .Central_African_Republic,
            Country.Chad.alpha2Code: .Chad,
            Country.Chile.alpha2Code: .Chile,
            Country.China.alpha2Code: .China,
            Country.Christmas_Island.alpha2Code: .Christmas_Island,
            Country.Cocos_Islands.alpha2Code: .Cocos_Islands,
            Country.Colombia.alpha2Code: .Colombia,
            Country.Comoros.alpha2Code: .Comoros,
            Country.Congo_Democratic_Republic.alpha2Code: .Congo_Democratic_Republic,
            Country.Congo.alpha2Code: .Congo,
            Country.Cook_Islands.alpha2Code: .Cook_Islands,
            Country.Costa_Rica.alpha2Code: .Costa_Rica,
            Country.Cote_d_Ivoire.alpha2Code: .Cote_d_Ivoire,
            Country.Croatia.alpha2Code: .Croatia,
            Country.Cuba.alpha2Code: .Cuba,
            Country.Curacao.alpha2Code: .Curacao,
            Country.Cyprus.alpha2Code: .Cyprus,
            Country.Czechia.alpha2Code: .Czechia,
            Country.Denmark.alpha2Code: .Denmark,
            Country.Djibouti.alpha2Code: .Djibouti,
            Country.Dominica.alpha2Code: .Dominica,
            Country.Dominican_Republic.alpha2Code: .Dominican_Republic,
            Country.Ecuador.alpha2Code: .Ecuador,
            Country.Egypt.alpha2Code: .Egypt,
            Country.El_Salvador.alpha2Code: .El_Salvador,
            Country.Equatorial_Guinea.alpha2Code: .Equatorial_Guinea,
            Country.Eritrea.alpha2Code: .Eritrea,
            Country.Estonia.alpha2Code: .Estonia,
            Country.Ethiopia.alpha2Code: .Ethiopia,
            Country.Falkland_Islands.alpha2Code: .Falkland_Islands,
            Country.Faroe_Islands.alpha2Code: .Faroe_Islands,
            Country.Fiji.alpha2Code: .Fiji,
            Country.Finland.alpha2Code: .Finland,
            Country.France.alpha2Code: .France,
            Country.French_Guiana.alpha2Code: .French_Guiana,
            Country.French_Polynesia.alpha2Code: .French_Polynesia,
            Country.French_Southern_Territories.alpha2Code: .French_Southern_Territories,
            Country.Gabon.alpha2Code: .Gabon,
            Country.Gambia.alpha2Code: .Gambia,
            Country.Georgia.alpha2Code: .Georgia,
            Country.Germany.alpha2Code: .Germany,
            Country.Ghana.alpha2Code: .Ghana,
            Country.Gibraltar.alpha2Code: .Gibraltar,
            Country.Greece.alpha2Code: .Greece,
            Country.Greenland.alpha2Code: .Greenland,
            Country.Grenada.alpha2Code: .Grenada,
            Country.Guadeloupe.alpha2Code: .Guadeloupe,
            Country.Guam.alpha2Code: .Guam,
            Country.Guatemala.alpha2Code: .Guatemala,
            Country.Guernsey.alpha2Code: .Guernsey,
            Country.Guinea.alpha2Code: .Guinea,
            Country.Guinea_Bissau.alpha2Code: .Guinea_Bissau,
            Country.Guyana.alpha2Code: .Guyana,
            Country.Haiti.alpha2Code: .Haiti,
            Country.Heard_Island_and_McDonald_Islands.alpha2Code: .Heard_Island_and_McDonald_Islands,
            Country.Vatican.alpha2Code: .Vatican,
            Country.Honduras.alpha2Code: .Honduras,
            Country.Hong_Kong.alpha2Code: .Hong_Kong,
            Country.Hungary.alpha2Code: .Hungary,
            Country.Iceland.alpha2Code: .Iceland,
            Country.India.alpha2Code: .India,
            Country.Indonesia.alpha2Code: .Indonesia,
            Country.Iran.alpha2Code: .Iran,
            Country.Iraq.alpha2Code: .Iraq,
            Country.Ireland.alpha2Code: .Ireland,
            Country.Isle_of_Man.alpha2Code: .Isle_of_Man,
            Country.Israel.alpha2Code: .Israel,
            Country.Italy.alpha2Code: .Italy,
            Country.Jamaica.alpha2Code: .Jamaica,
            Country.Japan.alpha2Code: .Japan,
            Country.Jersey.alpha2Code: .Jersey,
            Country.Jordan.alpha2Code: .Jordan,
            Country.Kazakhstan.alpha2Code: .Kazakhstan,
            Country.Kenya.alpha2Code: .Kenya,
            Country.Kiribati.alpha2Code: .Kiribati,
            Country.Kuwait.alpha2Code: .Kuwait,
            Country.Kyrgyzstan.alpha2Code: .Kyrgyzstan,
            Country.Lao.alpha2Code: .Lao,
            Country.Latvia.alpha2Code: .Latvia,
            Country.Lebanon.alpha2Code: .Lebanon,
            Country.Lesotho.alpha2Code: .Lesotho,
            Country.Liberia.alpha2Code: .Liberia,
            Country.Libya.alpha2Code: .Libya,
            Country.Liechtenstein.alpha2Code: .Liechtenstein,
            Country.Lithuania.alpha2Code: .Lithuania,
            Country.Luxembourg.alpha2Code: .Luxembourg,
            Country.Macao.alpha2Code: .Macao,
            Country.North_Macedonia.alpha2Code: .North_Macedonia,
            Country.Madagascar.alpha2Code: .Madagascar,
            Country.Malawi.alpha2Code: .Malawi,
            Country.Malaysia.alpha2Code: .Malaysia,
            Country.Maldives.alpha2Code: .Maldives,
            Country.Mali.alpha2Code: .Mali,
            Country.Malta.alpha2Code: .Malta,
            Country.Marshall_Islands.alpha2Code: .Marshall_Islands,
            Country.Martinique.alpha2Code: .Martinique,
            Country.Mauritania.alpha2Code: .Mauritania,
            Country.Mauritius.alpha2Code: .Mauritius,
            Country.Mayotte.alpha2Code: .Mayotte,
            Country.Micronesia.alpha2Code: .Micronesia,
            Country.Moldova.alpha2Code: .Moldova,
            Country.Monaco.alpha2Code: .Monaco,
            Country.Mongolia.alpha2Code: .Mongolia,
            Country.Montenegro.alpha2Code: .Montenegro,
            Country.Montserrat.alpha2Code: .Montserrat,
            Country.Morocco.alpha2Code: .Morocco,
            Country.Mozambique.alpha2Code: .Mozambique,
            Country.Myanmar.alpha2Code: .Myanmar,
            Country.Namibia.alpha2Code: .Namibia,
            Country.Nauru.alpha2Code: .Nauru,
            Country.Nepal.alpha2Code: .Nepal,
            Country.Netherlands.alpha2Code: .Netherlands,
            Country.New_Caledonia.alpha2Code: .New_Caledonia,
            Country.New_Zealand.alpha2Code: .New_Zealand,
            Country.Nicaragua.alpha2Code: .Nicaragua,
            Country.Niger.alpha2Code: .Niger,
            Country.Nigeria.alpha2Code: .Nigeria,
            Country.Niue.alpha2Code: .Niue,
            Country.Norfolk_Island.alpha2Code: .Norfolk_Island,
            Country.North_Korea.alpha2Code: .North_Korea,
            Country.Northern_Mariana_Islands.alpha2Code: .Northern_Mariana_Islands,
            Country.Norway.alpha2Code: .Norway,
            Country.Oman.alpha2Code: .Oman,
            Country.Pakistan.alpha2Code: .Pakistan,
            Country.Palau.alpha2Code: .Palau,
            Country.Palestine.alpha2Code: .Palestine,
            Country.Panama.alpha2Code: .Panama,
            Country.Papua_New_Guinea.alpha2Code: .Papua_New_Guinea,
            Country.Paraguay.alpha2Code: .Paraguay,
            Country.Peru.alpha2Code: .Peru,
            Country.Philippines.alpha2Code: .Philippines,
            Country.Pitcairn.alpha2Code: .Pitcairn,
            Country.Poland.alpha2Code: .Poland,
            Country.Portugal.alpha2Code: .Portugal,
            Country.Puerto_Rico.alpha2Code: .Puerto_Rico,
            Country.Qatar.alpha2Code: .Qatar,
            Country.Reunion.alpha2Code: .Reunion,
            Country.Romania.alpha2Code: .Romania,
            Country.Russia.alpha2Code: .Russia,
            Country.Rwanda.alpha2Code: .Rwanda,
            Country.Saint_Barthelemy.alpha2Code: .Saint_Barthelemy,
            Country.Saint_Helena.alpha2Code: .Saint_Helena,
            Country.Saint_Kitts_and_Nevis.alpha2Code: .Saint_Kitts_and_Nevis,
            Country.Saint_Lucia.alpha2Code: .Saint_Lucia,
            Country.Saint_Martin.alpha2Code: .Saint_Martin,
            Country.Saint_Pierre_and_Miquelon.alpha2Code: .Saint_Pierre_and_Miquelon,
            Country.Saint_Vincent_and_the_Grenadines.alpha2Code: .Saint_Vincent_and_the_Grenadines,
            Country.Samoa.alpha2Code: .Samoa,
            Country.San_Marino.alpha2Code: .San_Marino,
            Country.Sao_Tome_and_Principe.alpha2Code: .Sao_Tome_and_Principe,
            Country.Saudi_Arabia.alpha2Code: .Saudi_Arabia,
            Country.Senegal.alpha2Code: .Senegal,
            Country.Serbia.alpha2Code: .Serbia,
            Country.Seychelles.alpha2Code: .Seychelles,
            Country.Sierra_Leone.alpha2Code: .Sierra_Leone,
            Country.Singapore.alpha2Code: .Singapore,
            Country.Sint_Maarten.alpha2Code: .Sint_Maarten,
            Country.Slovakia.alpha2Code: .Slovakia,
            Country.Slovenia.alpha2Code: .Slovenia,
            Country.Solomon_Islands.alpha2Code: .Solomon_Islands,
            Country.Somalia.alpha2Code: .Somalia,
            Country.South_Africa.alpha2Code: .South_Africa,
            Country.South_Georgia_and_Sandwich_Islands.alpha2Code: .South_Georgia_and_Sandwich_Islands,
            Country.South_Korea.alpha2Code: .South_Korea,
            Country.South_Sudan.alpha2Code: .South_Sudan,
            Country.Spain.alpha2Code: .Spain,
            Country.Sri_Lanka.alpha2Code: .Sri_Lanka,
            Country.Sudan.alpha2Code: .Sudan,
            Country.Suriname.alpha2Code: .Suriname,
            Country.Svalbard_and_Jan_Mayen.alpha2Code: .Svalbard_and_Jan_Mayen,
            Country.Swaziland.alpha2Code: .Swaziland,
            Country.Sweden.alpha2Code: .Sweden,
            Country.Switzerland.alpha2Code: .Switzerland,
            Country.Syria.alpha2Code: .Syria,
            Country.Taiwan.alpha2Code: .Taiwan,
            Country.Tajikistan.alpha2Code: .Tajikistan,
            Country.Tanzania.alpha2Code: .Tanzania,
            Country.Thailand.alpha2Code: .Thailand,
            Country.Timor_Leste.alpha2Code: .Timor_Leste,
            Country.Togo.alpha2Code: .Togo,
            Country.Tokelau.alpha2Code: .Tokelau,
            Country.Tonga.alpha2Code: .Tonga,
            Country.Trinidad_and_Tobago.alpha2Code: .Trinidad_and_Tobago,
            Country.Tunisia.alpha2Code: .Tunisia,
            Country.Turkey.alpha2Code: .Turkey,
            Country.Turkmenistan.alpha2Code: .Turkmenistan,
            Country.Turks_and_Caicos_Islands.alpha2Code: .Turks_and_Caicos_Islands,
            Country.Tuvalu.alpha2Code: .Tuvalu,
            Country.United_Kingdom.alpha2Code: .United_Kingdom,
            Country.US_Minor_Outlying_Islands.alpha2Code: .US_Minor_Outlying_Islands,
            Country.Uganda.alpha2Code: .Uganda,
            Country.Ukraine.alpha2Code: .Ukraine,
            Country.United_Arab_Emirates.alpha2Code: .United_Arab_Emirates,
            Country.Uruguay.alpha2Code: .Uruguay,
            Country.Uzbekistan.alpha2Code: .Uzbekistan,
            Country.Vanuatu.alpha2Code: .Vanuatu,
            Country.Venezuela.alpha2Code: .Venezuela,
            Country.Viet_Nam.alpha2Code: .Viet_Nam,
            Country.British_Virgin_Islands.alpha2Code: .British_Virgin_Islands,
            Country.US_Virgin_Islands.alpha2Code: .US_Virgin_Islands,
            Country.Wallis_and_Futuna.alpha2Code: .Wallis_and_Futuna,
            Country.Western_Sahara.alpha2Code: .Western_Sahara,
            Country.Yemen.alpha2Code: .Yemen,
            Country.Zambia.alpha2Code: .Zambia,
            Country.Zimbabwe.alpha2Code: .Zimbabwe
        ]
    }()
    
    public func find(by locale: Locale) -> Country {
        if let validRegionCode = locale.regionCode?.uppercased() {
            return allKnownCountries[validRegionCode] ?? .Unknown
        } else {
            return .Unknown
        }
    }
    
    public func find(alpha2Code: String) -> Country {
        let uppercasedAlpha2Code = alpha2Code.uppercased()
        if uppercasedAlpha2Code == Country.Worldwide.alpha2Code {
            return .Worldwide
        } else if let matchingCountry = allKnownCountries[uppercasedAlpha2Code] {
            return matchingCountry
        } else {
            return .Unknown
        }
    }
    
    public func find(alpha3Code: String) -> Country {
        if alpha3Code == Country.Worldwide.alpha3Code {
            return .Worldwide
        } else if let matchingCountry = allKnownCountries.first(where: {$1.alpha3Code.uppercased() == alpha3Code.uppercased() }) {
            return matchingCountry.value
        } else {
            return .Unknown
        }
    }
}
