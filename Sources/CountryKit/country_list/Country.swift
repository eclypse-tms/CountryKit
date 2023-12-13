//
//  Country.swift
//  
//
//  Created by eclypse on 12/8/23.
//

import Foundation

/// a type that represents country
public struct Country: Hashable, Identifiable, CustomDebugStringConvertible, Codable {
    /// alias for alpha2Code
    public var id: String {
        return alpha2Code
    }
    
    ///ISO 3166-1 alpha-2 country code - see: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
    public let alpha2Code: String
    
    ///non-localized english name of this country
    public let englishName: String
    
    ///ISO 3166-1 alpha-3 country code - see: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
    public let alpha3Code: String
    
    ///localized name
    public let localizedName: String
    
    ///returns a list of applicable address fields in this locale
    public let addressLabels: [AddressLabel]
    
    ///when entering address, some countries like China prefers to present the address fields in a descending scope.
    ///from the largest address units (province) to the smallest address units (street). For most countries, this will be true.
    public let preferesAscendingAddressScope: Bool
    
    /// frequently associated locales with this country. one of the locales may be the most commonly used locale.
    /// some countries may not have any locales associated with them.
    public var locales: [Locale] = []
    
    public init(alpha3Code: String, englishName: String, alpha2Code: String,
                addressLabels: [AddressLabel] = [],
                preferesAscendingAddressScope: Bool = true,
                localizedNameOverride: String? = nil) {
        self.alpha3Code = alpha3Code
        self.englishName = englishName
        self.alpha2Code = alpha2Code
        switch alpha2Code {
        case "WW":
            self.localizedName = localizedNameOverride ?? "country_worldwide".localize()
        case "_U":
            self.localizedName = localizedNameOverride ?? "country_unknown".localize()
        default:
            self.localizedName = localizedNameOverride ?? Locale.autoupdatingCurrent.localizedString(forRegionCode: alpha2Code) ?? englishName
        }
        
        if addressLabels.isEmpty {
            self.addressLabels = AddressLabel.defaultList + [.country]
        } else {
            self.addressLabels = addressLabels + [.country]
        }
        
        self.preferesAscendingAddressScope = preferesAscendingAddressScope
    }
    
    public var debugDescription: String {
        return "alpha3Code: \(alpha3Code), name: \(englishName)"
    }
        
    public static let Afghanistan = Country(alpha3Code: "AFG", englishName: "Afghanistan", alpha2Code: "AF", addressLabels: AddressLabel.cityOnly)
    public static let Aland_Islands = Country(alpha3Code: "ALA", englishName: "Åland Islands", alpha2Code: "AX")
    public static let Albania = Country(alpha3Code: "ALB", englishName: "Albania", alpha2Code: "AL", addressLabels: AddressLabel.cityOnly)
    public static let Algeria = Country(alpha3Code: "DZA", englishName: "Algeria", alpha2Code: "DZ", addressLabels: AddressLabel.cityAndPostal)
    public static let American_Samoa = Country(alpha3Code: "ASM", englishName: "American Samoa", alpha2Code: "AS", addressLabels: [.street1, .street2, .city, .state, .zipCode])
    public static let Andorra = Country(alpha3Code: "AND", englishName: "Andorra", alpha2Code: "AD", addressLabels: AddressLabel.cityAndPostal)
    public static let Angola = Country(alpha3Code: "AGO", englishName: "Angola", alpha2Code: "AO", addressLabels: AddressLabel.cityOnly)
    public static let Anguilla = Country(alpha3Code: "AIA", englishName: "Anguilla", alpha2Code: "AI", addressLabels: [.street1, .street2, .district])
    public static let Antarctica = Country(alpha3Code: "ATA", englishName: "Antarctica", alpha2Code: "AQ")
    public static let Antigua_and_Barbuda = Country(alpha3Code: "ATG", englishName: "Antigua and Barbuda", alpha2Code: "AG", addressLabels: AddressLabel.cityOnly)
    public static let Argentina = Country(alpha3Code: "ARG", englishName: "Argentina", alpha2Code: "AR", addressLabels: AddressLabel.defaultList)
    public static let Armenia = Country(alpha3Code: "ARM", englishName: "Armenia", alpha2Code: "AM", addressLabels: AddressLabel.cityAndPostal)
    public static let Aruba = Country(alpha3Code: "ABW", englishName: "Aruba", alpha2Code: "AW", addressLabels: AddressLabel.cityOnly)
    public static let Australia = Country(alpha3Code: "AUS", englishName: "Australia", alpha2Code: "AU", addressLabels: [.street1, .street2, .suburb, .state, .postalCode])
    public static let Austria = Country(alpha3Code: "AUT", englishName: "Austria", alpha2Code: "AT", addressLabels: AddressLabel.cityAndPostal)
    public static let Azerbaijan = Country(alpha3Code: "AZE", englishName: "Azerbaijan", alpha2Code: "AZ", addressLabels: AddressLabel.cityAndPostal)
    public static let Bahamas = Country(alpha3Code: "BHS", englishName: "Bahamas", alpha2Code: "BS", addressLabels: [.street1, .street2, .city, .island])
    public static let Bahrain = Country(alpha3Code: "BHR", englishName: "Bahrain", alpha2Code: "BH", addressLabels: AddressLabel.cityAndPostal)
    public static let Bangladesh = Country(alpha3Code: "BGD", englishName: "Bangladesh", alpha2Code: "BD", addressLabels: AddressLabel.cityAndPostal)
    public static let Barbados = Country(alpha3Code: "BRB", englishName: "Barbados", alpha2Code: "BB", addressLabels: AddressLabel.cityOnly)
    public static let Belarus = Country(alpha3Code: "BLR", englishName: "Belarus", alpha2Code: "BY", addressLabels: AddressLabel.defaultList)
    public static let Belgium = Country(alpha3Code: "BEL", englishName: "Belgium", alpha2Code: "BE", addressLabels: AddressLabel.cityAndPostal)
    public static let Belize = Country(alpha3Code: "BLZ", englishName: "Belize", alpha2Code: "BZ", addressLabels: [.street1, .street2, .city, .province])
    public static let Benin = Country(alpha3Code: "BEN", englishName: "Benin", alpha2Code: "BJ", addressLabels: AddressLabel.cityOnly)
    public static let Bermuda = Country(alpha3Code: "BMU", englishName: "Bermuda", alpha2Code: "BM", addressLabels: AddressLabel.cityAndPostal)
    public static let Bhutan = Country(alpha3Code: "BTN", englishName: "Bhutan", alpha2Code: "BT", addressLabels: AddressLabel.cityOnly)
    public static let Bolivia = Country(alpha3Code: "BOL", englishName: "Bolivia", alpha2Code: "BO", addressLabels: AddressLabel.cityAndPostal)
    public static let Bonaire_Sint_Eustatius_and_Saba = Country(alpha3Code: "BES", englishName: "Bonaire, Sint Eustatius and Saba", alpha2Code: "BQ", addressLabels: [.street1, .street2, .city, .island])
    public static let Bosnia_and_Herzegovina = Country(alpha3Code: "BIH", englishName: "Bosnia and Herzegovina", alpha2Code: "BA", addressLabels: AddressLabel.cityAndPostal)
    public static let Botswana = Country(alpha3Code: "BWA", englishName: "Botswana", alpha2Code: "BW", addressLabels: AddressLabel.cityOnly)
    public static let Bouvet_Island = Country(alpha3Code: "BVT", englishName: "Bouvet Island", alpha2Code: "BV")
    public static let Brazil = Country(alpha3Code: "BRA", englishName: "Brazil", alpha2Code: "BR", addressLabels: [.street1, .street2, .neighborhood, .city, .state, .postalCode])
    public static let British_Indian_Ocean_Territory = Country(alpha3Code: "IOT", englishName: "British Indian Ocean Territory", alpha2Code: "IO")
    public static let Brunei = Country(alpha3Code: "BRN", englishName: "Brunei Darussalam", alpha2Code: "BN", addressLabels: AddressLabel.cityAndPostal)
    public static let Bulgaria = Country(alpha3Code: "BGR", englishName: "Bulgaria", alpha2Code: "BG", addressLabels: AddressLabel.cityAndPostal)
    public static let Burkina_Faso = Country(alpha3Code: "BFA", englishName: "Burkina Faso", alpha2Code: "BF", addressLabels: AddressLabel.cityAndPostal)
    public static let Burundi = Country(alpha3Code: "BDI", englishName: "Burundi", alpha2Code: "BI", addressLabels: AddressLabel.cityOnly)
    public static let Cape_Verde = Country(alpha3Code: "CPV", englishName: "Cape Verde", alpha2Code: "CV", addressLabels: AddressLabel.cityAndPostal)
    public static let Cambodia = Country(alpha3Code: "KHM", englishName: "Cambodia", alpha2Code: "KH", addressLabels: AddressLabel.cityAndPostal)
    public static let Cameroon = Country(alpha3Code: "CMR", englishName: "Cameroon", alpha2Code: "CM", addressLabels: AddressLabel.cityOnly)
    public static let Canada = Country(alpha3Code: "CAN", englishName: "Canada", alpha2Code: "CA", addressLabels: AddressLabel.defaultList)
    public static let Cayman_Islands = Country(alpha3Code: "CYM", englishName: "Cayman Islands", alpha2Code: "KY", addressLabels: [.street1, .street2, .island])
    public static let Central_African_Republic = Country(alpha3Code: "CAF", englishName: "Central African Republic", alpha2Code: "CF", addressLabels: AddressLabel.cityOnly)
    public static let Chad = Country(alpha3Code: "TCD", englishName: "Chad", alpha2Code: "TD", addressLabels: AddressLabel.cityOnly)
    public static let Chile = Country(alpha3Code: "CHL", englishName: "Chile", alpha2Code: "CL", addressLabels: AddressLabel.cityAndPostal)
    public static let China = Country(alpha3Code: "CHN", englishName: "China", alpha2Code: "CN", addressLabels: [.street1, .street2, .district, .city, .province, .postalCode], preferesAscendingAddressScope: false)
    public static let Christmas_Island = Country(alpha3Code: "CXR", englishName: "Christmas Island", alpha2Code: "CX")
    public static let Cocos_Islands = Country(alpha3Code: "CCK", englishName: "Cocos Islands", alpha2Code: "CC")
    public static let Colombia = Country(alpha3Code: "COL", englishName: "Colombia", alpha2Code: "CO", addressLabels: [.street1, .street2, .city, .department, .postalCode])
    public static let Comoros = Country(alpha3Code: "COM", englishName: "Comoros", alpha2Code: "KM", addressLabels: AddressLabel.cityOnly)
    public static let Congo_Democratic_Republic = Country(alpha3Code: "COD", englishName: "Congo Democratic Republic", alpha2Code: "CD", addressLabels: AddressLabel.cityOnly)
    public static let Congo = Country(alpha3Code: "COG", englishName: "Congo", alpha2Code: "CG", addressLabels: AddressLabel.cityAndPostal)
    public static let Cook_Islands = Country(alpha3Code: "COK", englishName: "Cook Islands", alpha2Code: "CK", addressLabels: [.street1, .street2, .island])
    public static let Costa_Rica = Country(alpha3Code: "CRI", englishName: "Costa Rica", alpha2Code: "CR", addressLabels: AddressLabel.cityAndPostal)
    public static let Cote_d_Ivoire = Country(alpha3Code: "CIV", englishName: "Côte d'Ivoire", alpha2Code: "CI", addressLabels: AddressLabel.cityAndPostal)
    public static let Croatia = Country(alpha3Code: "HRV", englishName: "Croatia", alpha2Code: "HR", addressLabels: AddressLabel.cityAndPostal)
    public static let Cuba = Country(alpha3Code: "CUB", englishName: "Cuba", alpha2Code: "CU", addressLabels: AddressLabel.cityAndPostal)
    public static let Curacao = Country(alpha3Code: "CUW", englishName: "Curaçao", alpha2Code: "CW", addressLabels: AddressLabel.cityOnly)
    public static let Cyprus = Country(alpha3Code: "CYP", englishName: "Cyprus", alpha2Code: "CY", addressLabels: AddressLabel.cityAndPostal)
    public static let Czechia = Country(alpha3Code: "CZE", englishName: "Czechia", alpha2Code: "CZ", addressLabels: AddressLabel.cityAndPostal)
    public static let Denmark = Country(alpha3Code: "DNK", englishName: "Denmark", alpha2Code: "DK", addressLabels: AddressLabel.cityAndPostal)
    public static let Djibouti = Country(alpha3Code: "DJI", englishName: "Djibouti", alpha2Code: "DJ", addressLabels: AddressLabel.cityOnly)
    public static let Dominica = Country(alpha3Code: "DMA", englishName: "Dominica", alpha2Code: "DM", addressLabels: AddressLabel.cityOnly)
    public static let Dominican_Republic = Country(alpha3Code: "DOM", englishName: "Dominican Republic", alpha2Code: "DO", addressLabels: [.street1, .street2, .postalDistrict, .postalCode, .city])
    public static let Ecuador = Country(alpha3Code: "ECU", englishName: "Ecuador", alpha2Code: "EC", addressLabels: AddressLabel.cityAndPostal)
    public static let Egypt = Country(alpha3Code: "EGY", englishName: "Egypt", alpha2Code: "EG", addressLabels: [.street1, .street2, .district, .governorate])
    public static let El_Salvador = Country(alpha3Code: "SLV", englishName: "El Salvador", alpha2Code: "SV", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    public static let Equatorial_Guinea = Country(alpha3Code: "GNQ", englishName: "Equatorial Guinea", alpha2Code: "GQ", addressLabels: AddressLabel.cityOnly)
    public static let Eritrea = Country(alpha3Code: "ERI", englishName: "Eritrea", alpha2Code: "ER", addressLabels: AddressLabel.cityOnly)
    public static let Estonia = Country(alpha3Code: "EST", englishName: "Estonia", alpha2Code: "EE", addressLabels: AddressLabel.cityAndPostal)
    public static let Ethiopia = Country(alpha3Code: "ETH", englishName: "Ethiopia", alpha2Code: "ET", addressLabels: AddressLabel.cityAndPostal)
    public static let Falkland_Islands = Country(alpha3Code: "FLK", englishName: "Falkland Islands", alpha2Code: "FK", addressLabels: AddressLabel.cityAndPostal)
    public static let Faroe_Islands = Country(alpha3Code: "FRO", englishName: "Faroe Islands", alpha2Code: "FO", addressLabels: AddressLabel.cityAndPostal)
    public static let Fiji = Country(alpha3Code: "FJI", englishName: "Fiji", alpha2Code: "FJ", addressLabels: [.street1, .street2, .city, .island])
    public static let Finland = Country(alpha3Code: "FIN", englishName: "Finland", alpha2Code: "FI", addressLabels: AddressLabel.cityAndPostal)
    public static let France = Country(alpha3Code: "FRA", englishName: "France", alpha2Code: "FR", addressLabels: AddressLabel.cityAndPostal)
    public static let French_Guiana = Country(alpha3Code: "GUF", englishName: "French Guiana", alpha2Code: "GF", addressLabels: AddressLabel.cityAndPostal)
    public static let French_Polynesia = Country(alpha3Code: "PYF", englishName: "French Polynesia", alpha2Code: "PF", addressLabels: [.street1, .street2, .postalCode, .city, .island])
    public static let French_Southern_Territories = Country(alpha3Code: "ATF", englishName: "French Southern Territories", alpha2Code: "TF")
    public static let Gabon = Country(alpha3Code: "GAB", englishName: "Gabon", alpha2Code: "GA", addressLabels: AddressLabel.cityAndPostal)
    public static let Gambia = Country(alpha3Code: "GMB", englishName: "Gambia", alpha2Code: "GM", addressLabels: AddressLabel.cityOnly)
    public static let Georgia = Country(alpha3Code: "GEO", englishName: "Georgia", alpha2Code: "GE", addressLabels: AddressLabel.cityAndPostal)
    public static let Germany = Country(alpha3Code: "DEU", englishName: "Germany", alpha2Code: "DE", addressLabels: AddressLabel.cityAndPostal)
    public static let Ghana = Country(alpha3Code: "GHA", englishName: "Ghana", alpha2Code: "GH", addressLabels: AddressLabel.cityOnly)
    public static let Gibraltar = Country(alpha3Code: "GIB", englishName: "Gibraltar", alpha2Code: "GI", addressLabels: AddressLabel.cityAndPostal)
    public static let Greece = Country(alpha3Code: "GRC", englishName: "Greece", alpha2Code: "GR", addressLabels: AddressLabel.cityAndPostal)
    public static let Greenland = Country(alpha3Code: "GRL", englishName: "Greenland", alpha2Code: "GL", addressLabels: AddressLabel.cityAndPostal)
    public static let Grenada = Country(alpha3Code: "GRD", englishName: "Grenada", alpha2Code: "GD", addressLabels: AddressLabel.cityOnly)
    public static let Guadeloupe = Country(alpha3Code: "GLP", englishName: "Guadeloupe", alpha2Code: "GP", addressLabels: AddressLabel.cityAndPostal)
    public static let Guam = Country(alpha3Code: "GUM", englishName: "Guam", alpha2Code: "GU", addressLabels: [.street1, .street2, .city, .state, .zipCode])
    public static let Guatemala = Country(alpha3Code: "GTM", englishName: "Guatemala", alpha2Code: "GT", addressLabels: AddressLabel.cityAndPostal)
    public static let Guernsey = Country(alpha3Code: "GGY", englishName: "Guernsey", alpha2Code: "GG")
    public static let Guinea = Country(alpha3Code: "GIN", englishName: "Guinea", alpha2Code: "GN", addressLabels: AddressLabel.cityAndPostal)
    public static let Guinea_Bissau = Country(alpha3Code: "GNB", englishName: "Guinea-Bissau", alpha2Code: "GW", addressLabels: AddressLabel.cityAndPostal)
    public static let Guyana = Country(alpha3Code: "GUY", englishName: "Guyana", alpha2Code: "GY", addressLabels: AddressLabel.cityOnly)
    public static let Haiti = Country(alpha3Code: "HTI", englishName: "Haiti", alpha2Code: "HT", addressLabels: AddressLabel.cityAndPostal)
    public static let Heard_Island_and_McDonald_Islands = Country(alpha3Code: "HMD", englishName: "Heard_Island_and_McDonald_Islands", alpha2Code: "HM")
    public static let Vatican = Country(alpha3Code: "VAT", englishName: "Holy See", alpha2Code: "VA", addressLabels: AddressLabel.cityAndPostal)
    public static let Honduras = Country(alpha3Code: "HND", englishName: "Honduras", alpha2Code: "HN", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    public static let Hong_Kong = Country(alpha3Code: "HKG", englishName: "Hong Kong", alpha2Code: "HK", addressLabels: [.street1, .street2, .region, .district], preferesAscendingAddressScope: false)
    public static let Hungary = Country(alpha3Code: "HUN", englishName: "Hungary", alpha2Code: "HU", addressLabels: AddressLabel.cityAndPostal, preferesAscendingAddressScope: false)
    public static let Iceland = Country(alpha3Code: "ISL", englishName: "Iceland", alpha2Code: "IS", addressLabels: AddressLabel.cityAndPostal)
    public static let India = Country(alpha3Code: "IND", englishName: "India", alpha2Code: "IN", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    public static let Indonesia = Country(alpha3Code: "IDN", englishName: "Indonesia", alpha2Code: "ID", addressLabels: AddressLabel.defaultList)
    public static let Iran = Country(alpha3Code: "IRN", englishName: "Iran", alpha2Code: "IR", addressLabels: AddressLabel.cityAndPostal)
    public static let Iraq = Country(alpha3Code: "IRQ", englishName: "Iraq", alpha2Code: "IQ", addressLabels: AddressLabel.cityAndPostal)
    public static let Ireland = Country(alpha3Code: "IRL", englishName: "Ireland", alpha2Code: "IE", addressLabels: [.street1, .street2, .city, .county, .postalCode])
    public static let Isle_of_Man = Country(alpha3Code: "IMN", englishName: "Isle of Man", alpha2Code: "IM", addressLabels: AddressLabel.cityAndPostal)
    public static let Israel = Country(alpha3Code: "ISR", englishName: "Israel", alpha2Code: "IL", addressLabels: AddressLabel.cityAndPostal)
    public static let Italy = Country(alpha3Code: "ITA", englishName: "Italy", alpha2Code: "IT", addressLabels: AddressLabel.defaultList)
    public static let Jamaica = Country(alpha3Code: "JAM", englishName: "Jamaica", alpha2Code: "JM", addressLabels: AddressLabel.cityAndPostal)
    public static let Japan = Country(alpha3Code: "JPN", englishName: "Japan", alpha2Code: "JP", addressLabels: [.street1, .street2, .city, .county, .prefecture, .postalCode], preferesAscendingAddressScope: false)
    public static let Jersey = Country(alpha3Code: "JEY", englishName: "Jersey", alpha2Code: "JE")
    public static let Jordan = Country(alpha3Code: "JOR", englishName: "Jordan", alpha2Code: "JO", addressLabels: [.street1, .street2, .city, .postalDistrict, .postalCode])
    public static let Kazakhstan = Country(alpha3Code: "KAZ", englishName: "Kazakhstan", alpha2Code: "KZ", addressLabels: [.street1, .street2, .city, .postalDistrict, .postalCode])
    public static let Kenya = Country(alpha3Code: "KEN", englishName: "Kenya", alpha2Code: "KE", addressLabels: AddressLabel.cityAndPostal)
    public static let Kiribati = Country(alpha3Code: "KIR", englishName: "Kiribati", alpha2Code: "KI", addressLabels: [.street1, .street2, .city, .island])
    public static let Kuwait = Country(alpha3Code: "KWT", englishName: "Kuwait", alpha2Code: "KW", addressLabels: AddressLabel.defaultList)
    public static let Kyrgyzstan = Country(alpha3Code: "KGZ", englishName: "Kyrgyzstan", alpha2Code: "KG", addressLabels: AddressLabel.cityAndPostal, preferesAscendingAddressScope: false)
    public static let Lao = Country(alpha3Code: "LAO", englishName: "Lao", alpha2Code: "LA", addressLabels: AddressLabel.cityAndPostal)
    public static let Latvia = Country(alpha3Code: "LVA", englishName: "Latvia", alpha2Code: "LV", addressLabels: AddressLabel.cityAndPostal)
    public static let Lebanon = Country(alpha3Code: "LBN", englishName: "Lebanon", alpha2Code: "LB", addressLabels: AddressLabel.cityAndPostal)
    public static let Lesotho = Country(alpha3Code: "LSO", englishName: "Lesotho", alpha2Code: "LS", addressLabels: AddressLabel.cityAndPostal)
    public static let Liberia = Country(alpha3Code: "LBR", englishName: "Liberia", alpha2Code: "LR", addressLabels: AddressLabel.cityAndPostal)
    public static let Libya = Country(alpha3Code: "LBY", englishName: "Libya", alpha2Code: "LY", addressLabels: AddressLabel.cityOnly)
    public static let Liechtenstein = Country(alpha3Code: "LIE", englishName: "Liechtenstein", alpha2Code: "LI", addressLabels: AddressLabel.cityAndPostal)
    public static let Lithuania = Country(alpha3Code: "LTU", englishName: "Lithuania", alpha2Code: "LT", addressLabels: AddressLabel.cityAndPostal)
    public static let Luxembourg = Country(alpha3Code: "LUX", englishName: "Luxembourg", alpha2Code: "LU", addressLabels: AddressLabel.cityAndPostal)
    public static let Macao = Country(alpha3Code: "MAC", englishName: "Macao", alpha2Code: "MO", addressLabels:[.street1, .street2, .district, .city], preferesAscendingAddressScope: false)
    public static let North_Macedonia = Country(alpha3Code: "MKD", englishName: "North Macedonia", alpha2Code: "MK", addressLabels: AddressLabel.cityAndPostal)
    public static let Madagascar = Country(alpha3Code: "MDG", englishName: "Madagascar", alpha2Code: "MG", addressLabels: AddressLabel.cityAndPostal)
    public static let Malawi = Country(alpha3Code: "MWI", englishName: "Malawi", alpha2Code: "MW", addressLabels: AddressLabel.cityAndPostal)
    public static let Malaysia = Country(alpha3Code: "MYS", englishName: "Malaysia", alpha2Code: "MY", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    public static let Maldives = Country(alpha3Code: "MDV", englishName: "Maldives", alpha2Code: "MV", addressLabels: AddressLabel.cityAndPostal)
    public static let Mali = Country(alpha3Code: "MLI", englishName: "Mali", alpha2Code: "ML", addressLabels: AddressLabel.cityOnly)
    public static let Malta = Country(alpha3Code: "MLT", englishName: "Malta", alpha2Code: "MT", addressLabels: AddressLabel.cityAndPostal)
    public static let Marshall_Islands = Country(alpha3Code: "MHL", englishName: "Marshall Islands", alpha2Code: "MH", addressLabels: AddressLabel.cityAndPostal)
    public static let Martinique = Country(alpha3Code: "MTQ", englishName: "Martinique", alpha2Code: "MQ", addressLabels: AddressLabel.cityAndPostal)
    public static let Mauritania = Country(alpha3Code: "MRT", englishName: "Mauritania", alpha2Code: "MR", addressLabels: AddressLabel.cityOnly)
    public static let Mauritius = Country(alpha3Code: "MUS", englishName: "Mauritius", alpha2Code: "MU", addressLabels: AddressLabel.cityAndPostal)
    public static let Mayotte = Country(alpha3Code: "MYT", englishName: "Mayotte", alpha2Code: "YT", addressLabels: AddressLabel.cityAndPostal)
    public static let Mexico = Country(alpha3Code: "MEX", englishName: "Mexico", alpha2Code: "MX", addressLabels: [.street1, .street2, .city, .postalCode, .postalCode])
    public static let Micronesia = Country(alpha3Code: "FSM", englishName: "Micronesia", alpha2Code: "FM", addressLabels: [.street1, .street2, .city, .state, .zipCode])
    public static let Moldova = Country(alpha3Code: "MDA", englishName: "Moldova", alpha2Code: "MD", addressLabels: AddressLabel.cityAndPostal)
    public static let Monaco = Country(alpha3Code: "MCO", englishName: "Monaco", alpha2Code: "MC", addressLabels: AddressLabel.cityAndPostal)
    public static let Mongolia = Country(alpha3Code: "MNG", englishName: "Mongolia", alpha2Code: "MN", addressLabels: AddressLabel.cityAndPostal)
    public static let Montenegro = Country(alpha3Code: "MNE", englishName: "Montenegro", alpha2Code: "ME", addressLabels: AddressLabel.cityAndPostal)
    public static let Montserrat = Country(alpha3Code: "MSR", englishName: "Montserrat", alpha2Code: "MS", addressLabels: AddressLabel.cityAndPostal)
    public static let Morocco = Country(alpha3Code: "MAR", englishName: "Morocco", alpha2Code: "MA", addressLabels: AddressLabel.cityAndPostal)
    public static let Mozambique = Country(alpha3Code: "MOZ", englishName: "Mozambique", alpha2Code: "MZ", addressLabels: AddressLabel.defaultList)
    public static let Myanmar = Country(alpha3Code: "MMR", englishName: "Myanmar", alpha2Code: "MM", addressLabels: AddressLabel.cityAndPostal)
    public static let Namibia = Country(alpha3Code: "NAM", englishName: "Namibia", alpha2Code: "NA", addressLabels: AddressLabel.cityOnly)
    public static let Nauru = Country(alpha3Code: "NRU", englishName: "Nauru", alpha2Code: "NR", addressLabels: [.street1, .street2, .district])
    public static let Nepal = Country(alpha3Code: "NPL", englishName: "Nepal", alpha2Code: "NP", addressLabels: AddressLabel.cityAndPostal)
    public static let Netherlands = Country(alpha3Code: "NLD", englishName: "Netherlands", alpha2Code: "NL", addressLabels: AddressLabel.cityAndPostal)
    public static let New_Caledonia = Country(alpha3Code: "NCL", englishName: "New Caledonia", alpha2Code: "NC", addressLabels: AddressLabel.cityAndPostal)
    public static let New_Zealand = Country(alpha3Code: "NZL", englishName: "New Zealand", alpha2Code: "NZ", addressLabels: [.street1, .street2, .suburb, .city, .postalCode])
    public static let Nicaragua = Country(alpha3Code: "NIC", englishName: "Nicaragua", alpha2Code: "NI", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    public static let Niger = Country(alpha3Code: "NER", englishName: "Niger", alpha2Code: "NE", addressLabels: AddressLabel.cityAndPostal)
    public static let Nigeria = Country(alpha3Code: "NGA", englishName: "Nigeria", alpha2Code: "NG", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    public static let Niue = Country(alpha3Code: "NIU", englishName: "Niue", alpha2Code: "NU")
    public static let Norfolk_Island = Country(alpha3Code: "NFK", englishName: "Norfolk Island", alpha2Code: "NF")
    public static let North_Korea = Country(alpha3Code: "PRK", englishName: "North Korea", alpha2Code: "KP", addressLabels: [.street1, .street2, .city, .province], preferesAscendingAddressScope: false)
    public static let Northern_Mariana_Islands = Country(alpha3Code: "MNP", englishName: "Northern Mariana Islands", alpha2Code: "MP")
    public static let Norway = Country(alpha3Code: "NOR", englishName: "Norway", alpha2Code: "NO", addressLabels: AddressLabel.cityAndPostal)
    public static let Oman = Country(alpha3Code: "OMN", englishName: "Oman", alpha2Code: "OM", addressLabels: AddressLabel.defaultList)
    public static let Pakistan = Country(alpha3Code: "PAK", englishName: "Pakistan", alpha2Code: "PK", addressLabels: AddressLabel.cityAndPostal)
    public static let Palau = Country(alpha3Code: "PLW", englishName: "Palau", alpha2Code: "PW", addressLabels: AddressLabel.usStyle)
    public static let Palestine = Country(alpha3Code: "PSE", englishName: "Palestine", alpha2Code: "PS", addressLabels: AddressLabel.cityAndPostal)
    public static let Panama = Country(alpha3Code: "PAN", englishName: "Panama", alpha2Code: "PA", addressLabels: AddressLabel.defaultList)
    public static let Papua_New_Guinea = Country(alpha3Code: "PNG", englishName: "Papua New Guinea", alpha2Code: "PG", addressLabels: AddressLabel.defaultList)
    public static let Paraguay = Country(alpha3Code: "PRY", englishName: "Paraguay", alpha2Code: "PY", addressLabels: AddressLabel.cityAndPostal)
    public static let Peru = Country(alpha3Code: "PER", englishName: "Peru", alpha2Code: "PE", addressLabels: AddressLabel.cityAndPostal)
    public static let Philippines = Country(alpha3Code: "PHL", englishName: "Philippines", alpha2Code: "PH", addressLabels: [.street1, .street2, .district, .city, .postalCode])
    public static let Pitcairn = Country(alpha3Code: "PCN", englishName: "Pitcairn", alpha2Code: "PN")
    public static let Poland = Country(alpha3Code: "POL", englishName: "Poland", alpha2Code: "PL", addressLabels: AddressLabel.cityAndPostal)
    public static let Portugal = Country(alpha3Code: "PRT", englishName: "Portugal", alpha2Code: "PT", addressLabels: AddressLabel.cityAndPostal)
    public static let Puerto_Rico = Country(alpha3Code: "PRI", englishName: "Puerto Rico", alpha2Code: "PR", addressLabels: AddressLabel.usStyle)
    public static let Qatar = Country(alpha3Code: "QAT", englishName: "Qatar", alpha2Code: "QA", addressLabels: AddressLabel.cityAndPostal)
    public static let Reunion = Country(alpha3Code: "REU", englishName: "Réunion", alpha2Code: "RE", addressLabels: AddressLabel.cityAndPostal)
    public static let Romania = Country(alpha3Code: "ROU", englishName: "Romania", alpha2Code: "RO", addressLabels: AddressLabel.cityAndPostal)
    public static let Russia = Country(alpha3Code: "RUS", englishName: "Russian Federation", alpha2Code: "RU", addressLabels: [.street1, .street2, .city, .subjectOfFederation, .postalCode])
    public static let Rwanda = Country(alpha3Code: "RWA", englishName: "Rwanda", alpha2Code: "RW", addressLabels: AddressLabel.cityOnly)
    public static let Saint_Barthelemy = Country(alpha3Code: "BLM", englishName: "Saint Barthélemy", alpha2Code: "BL", addressLabels: AddressLabel.cityAndPostal)
    public static let Saint_Helena = Country(alpha3Code: "SHN", englishName: "Saint Helena", alpha2Code: "SH", addressLabels: AddressLabel.cityAndPostal)
    public static let Saint_Kitts_and_Nevis = Country(alpha3Code: "KNA", englishName: "Saint Kitts and Nevis", alpha2Code: "KN", addressLabels: [.street1, .street2, .postalCode, .city, .island])
    public static let Saint_Lucia = Country(alpha3Code: "LCA", englishName: "Saint Lucia", alpha2Code: "LC", addressLabels: AddressLabel.cityOnly)
    public static let Saint_Martin = Country(alpha3Code: "MAF", englishName: "Saint Martin", alpha2Code: "MF", addressLabels: AddressLabel.cityAndPostal)
    public static let Saint_Pierre_and_Miquelon = Country(alpha3Code: "SPM", englishName: "Saint Pierre and Miquelon", alpha2Code: "PM")
    public static let Saint_Vincent_and_the_Grenadines = Country(alpha3Code: "VCT", englishName: "Saint Vincent and the Grenadines", alpha2Code: "VC", addressLabels: AddressLabel.cityOnly)
    public static let Samoa = Country(alpha3Code: "WSM", englishName: "Samoa", alpha2Code: "WS", addressLabels: AddressLabel.cityOnly)
    public static let San_Marino = Country(alpha3Code: "SMR", englishName: "San Marino", alpha2Code: "SM", addressLabels: AddressLabel.defaultList)
    public static let Sao_Tome_and_Principe = Country(alpha3Code: "STP", englishName: "Sao Tome and Principe", alpha2Code: "ST", addressLabels: AddressLabel.cityOnly)
    public static let Saudi_Arabia = Country(alpha3Code: "SAU", englishName: "Saudi Arabia", alpha2Code: "SA", addressLabels: [.street1, .street2, .district, .city, .postalCode])
    public static let Senegal = Country(alpha3Code: "SEN", englishName: "Senegal", alpha2Code: "SN", addressLabels: AddressLabel.cityAndPostal)
    public static let Serbia = Country(alpha3Code: "SRB", englishName: "Serbia", alpha2Code: "RS", addressLabels: AddressLabel.cityAndPostal)
    public static let Seychelles = Country(alpha3Code: "SYC", englishName: "Seychelles", alpha2Code: "SC", addressLabels: AddressLabel.cityOnly)
    public static let Sierra_Leone = Country(alpha3Code: "SLE", englishName: "Sierra Leone", alpha2Code: "SL", addressLabels: AddressLabel.cityOnly)
    public static let Singapore = Country(alpha3Code: "SGP", englishName: "Singapore", alpha2Code: "SG", addressLabels: AddressLabel.cityAndPostal)
    public static let Sint_Maarten = Country(alpha3Code: "SXM", englishName: "Sint Maarten", alpha2Code: "SX", addressLabels: AddressLabel.cityOnly)
    public static let Slovakia = Country(alpha3Code: "SVK", englishName: "Slovakia", alpha2Code: "SK", addressLabels: AddressLabel.cityAndPostal)
    public static let Slovenia = Country(alpha3Code: "SVN", englishName: "Slovenia", alpha2Code: "SI", addressLabels: AddressLabel.cityAndPostal)
    public static let Solomon_Islands = Country(alpha3Code: "SLB", englishName: "Solomon Islands", alpha2Code: "SB", addressLabels: AddressLabel.cityOnly)
    public static let Somalia = Country(alpha3Code: "SOM", englishName: "Somalia", alpha2Code: "SO", addressLabels: [.street1, .street2, .city, .region, .postalCode])
    public static let South_Africa = Country(alpha3Code: "ZAF", englishName: "South Africa", alpha2Code: "ZA", addressLabels: AddressLabel.defaultList)
    public static let South_Georgia_and_Sandwich_Islands = Country(alpha3Code: "SGS", englishName: "South_Georgia_and_Sandwich_Islands", alpha2Code: "GS", addressLabels: AddressLabel.cityAndPostal)
    public static let South_Korea = Country(alpha3Code: "KOR", englishName: "South Korea", alpha2Code: "KR", addressLabels: [.postalCode, .province, .city, .street1, .street2], preferesAscendingAddressScope: false)
    public static let South_Sudan = Country(alpha3Code: "SSD", englishName: "South Sudan", alpha2Code: "SS", addressLabels: AddressLabel.cityAndPostal)
    public static let Spain = Country(alpha3Code: "ESP", englishName: "Spain", alpha2Code: "ES", addressLabels: AddressLabel.defaultList)
    public static let Sri_Lanka = Country(alpha3Code: "LKA", englishName: "Sri Lanka", alpha2Code: "LK", addressLabels: AddressLabel.cityAndPostal)
    public static let Sudan = Country(alpha3Code: "SDN", englishName: "Sudan", alpha2Code: "SD", addressLabels: AddressLabel.cityAndPostal)
    public static let Suriname = Country(alpha3Code: "SUR", englishName: "Suriname", alpha2Code: "SR", addressLabels: [.street1, .street2, .city, .district])
    public static let Svalbard_and_Jan_Mayen = Country(alpha3Code: "SJM", englishName: "Svalbard and Jan Mayen", alpha2Code: "SJ")
    public static let Swaziland = Country(alpha3Code: "SWZ", englishName: "Swaziland", alpha2Code: "SZ", addressLabels: AddressLabel.cityAndPostal)
    public static let Sweden = Country(alpha3Code: "SWE", englishName: "Sweden", alpha2Code: "SE", addressLabels: AddressLabel.cityAndPostal)
    public static let Switzerland = Country(alpha3Code: "CHE", englishName: "Switzerland", alpha2Code: "CH", addressLabels: AddressLabel.cityAndPostal)
    public static let Syria = Country(alpha3Code: "SYR", englishName: "Syrian Arab Republic", alpha2Code: "SY", addressLabels: AddressLabel.cityAndPostal)
    public static let Taiwan = Country(alpha3Code: "TWN", englishName: "Taiwan", alpha2Code: "TW", addressLabels: [.zipCode, .county, .township, .street1, .street2], preferesAscendingAddressScope: false)
    public static let Tajikistan = Country(alpha3Code: "TJK", englishName: "Tajikistan", alpha2Code: "TJ", addressLabels: AddressLabel.cityAndPostal )
    public static let Tanzania = Country(alpha3Code: "TZA", englishName: "Tanzania", alpha2Code: "TZ", addressLabels: AddressLabel.cityOnly)
    public static let Thailand = Country(alpha3Code: "THA", englishName: "Thailand", alpha2Code: "TH", addressLabels: [.street1, .street2, .district, .province, .postalCode])
    public static let Timor_Leste = Country(alpha3Code: "TLS", englishName: "Timor-Leste", alpha2Code: "TL", addressLabels: AddressLabel.cityOnly)
    public static let Togo = Country(alpha3Code: "TGO", englishName: "Togo", alpha2Code: "TG", addressLabels: AddressLabel.cityOnly)
    public static let Tokelau = Country(alpha3Code: "TKL", englishName: "Tokelau", alpha2Code: "TK")
    public static let Tonga = Country(alpha3Code: "TON", englishName: "Tonga", alpha2Code: "TO", addressLabels: AddressLabel.cityOnly)
    public static let Trinidad_and_Tobago = Country(alpha3Code: "TTO", englishName: "Trinidad and Tobago", alpha2Code: "TT", addressLabels: AddressLabel.cityOnly)
    public static let Tunisia = Country(alpha3Code: "TUN", englishName: "Tunisia", alpha2Code: "TN", addressLabels: AddressLabel.cityAndPostal)
    public static let Turkey = Country(alpha3Code: "TUR", englishName: "Turkey", alpha2Code: "TR", addressLabels: [.street1, .street2, .postalCode, .district, .city])
    public static let Turkmenistan = Country(alpha3Code: "TKM", englishName: "Turkmenistan", alpha2Code: "TM", addressLabels: AddressLabel.cityAndPostal)
    public static let Turks_and_Caicos_Islands = Country(alpha3Code: "TCA", englishName: "Turks and Caicos Islands", alpha2Code: "TC", addressLabels: [.street1, .street2, .island])
    public static let Tuvalu = Country(alpha3Code: "TUV", englishName: "Tuvalu", alpha2Code: "TV", addressLabels: AddressLabel.cityOnly)
    public static let United_Kingdom = Country(alpha3Code: "GBR", englishName: "United Kingdom", alpha2Code: "GB", addressLabels: [.street1, .street2, .town, .county, .postalCode])
    public static let US_Minor_Outlying_Islands = Country(alpha3Code: "UMI", englishName: "U.S. Minor Outlying Islands", alpha2Code: "UM")
    public static let Uganda = Country(alpha3Code: "UGA", englishName: "Uganda", alpha2Code: "UG", addressLabels: AddressLabel.cityOnly)
    public static let Ukraine = Country(alpha3Code: "UKR", englishName: "Ukraine", alpha2Code: "UA", addressLabels: AddressLabel.defaultList)
    public static let United_Arab_Emirates = Country(alpha3Code: "ARE", englishName: "United Arab Emirates", alpha2Code: "AE", addressLabels: [.street1, .street2, .area, .city])
    public static let United_States = Country(alpha3Code: "USA", englishName: "United States", alpha2Code: "US", addressLabels: AddressLabel.usStyle)
    public static let Uruguay = Country(alpha3Code: "URY", englishName: "Uruguay", alpha2Code: "UY", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    public static let Uzbekistan = Country(alpha3Code: "UZB", englishName: "Uzbekistan", alpha2Code: "UZ", addressLabels: AddressLabel.cityAndPostal)
    public static let Vanuatu = Country(alpha3Code: "VUT", englishName: "Vanuatu", alpha2Code: "VU", addressLabels: AddressLabel.cityOnly)
    public static let Venezuela = Country(alpha3Code: "VEN", englishName: "Venezuela", alpha2Code: "VE", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    public static let Viet_Nam = Country(alpha3Code: "VNM", englishName: "Viet Nam", alpha2Code: "VN", addressLabels: AddressLabel.defaultList)
    public static let British_Virgin_Islands = Country(alpha3Code: "VGB", englishName: "Virgin Islands (British)", alpha2Code: "VG", addressLabels: AddressLabel.cityAndPostal)
    public static let US_Virgin_Islands = Country(alpha3Code: "VIR", englishName: "Virgin Islands (U.S.)", alpha2Code: "VI", addressLabels: AddressLabel.usStyle)
    public static let Wallis_and_Futuna = Country(alpha3Code: "WLF", englishName: "Wallis and Futuna", alpha2Code: "WF")
    public static let Western_Sahara = Country(alpha3Code: "ESH", englishName: "Western Sahara", alpha2Code: "EH")
    public static let Yemen = Country(alpha3Code: "YEM", englishName: "Yemen", alpha2Code: "YE", addressLabels: AddressLabel.cityAndPostal)
    public static let Zambia = Country(alpha3Code: "ZMB", englishName: "Zambia", alpha2Code: "ZM", addressLabels: AddressLabel.cityAndPostal)
    public static let Zimbabwe = Country(alpha3Code: "ZWE", englishName: "Zimbabwe", alpha2Code: "ZW", addressLabels: AddressLabel.cityOnly)
    

    public static var Worldwide = Country(alpha3Code: "WWC", englishName: "Worldwide", alpha2Code: "WW", localizedNameOverride: nil)
    public static var Unknown = Country(alpha3Code: "_UK", englishName: "Unknown Country", alpha2Code: "_U", localizedNameOverride: nil)
}
