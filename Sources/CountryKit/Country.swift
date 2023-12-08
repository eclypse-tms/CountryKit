//
//  Country.swift
//  
//
//  Created by Turker Nessa on 12/8/23.
//

import Foundation

/// a type that represents country
struct Country: Hashable, Identifiable, CustomDebugStringConvertible, Codable {
    /// alias for alpha3Code
    var id: String {
        return alpha3Code
    }
    
    ///non-localized english name of this country
    let englishName: String
    
    ///ISO 3166-1 alpha-3 country code - see: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
    let alpha3Code: String
    
    ///ISO 3166-1 alpha-2 country code - see: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
    let alpha2Code: String
    
    ///localized name
    let localizedName: String
    
    ///returns a list of applicable address fields in this locale
    let addressLabels: [AddressLabel]
    
    ///when entering address, some countries like China prefers to present the address fields in a descending scope.
    ///from the largest address units (province) to the smallest address units (street). For most countries, this will be true.
    let preferesAscendingAddressScope: Bool
    
    init(alpha3Code: String, englishName: String, alpha2Code: String, addressLabels: [AddressLabel] = [], preferesAscendingAddressScope: Bool = true) {
        self.alpha3Code = alpha3Code
        self.englishName = englishName
        self.alpha2Code = alpha2Code
        switch alpha2Code {
        case "WW":
            self.localizedName = "common_worldwide".localized()
        default:
            self.localizedName = Locale.autoupdatingCurrent.localizedString(forRegionCode: alpha2Code) ?? "\("unknown_country".localized()) (\(englishName)"
        }
        
        if addressLabels.isEmpty {
            self.addressLabels = AddressLabel.defaultList + [.country]
        } else {
            self.addressLabels = addressLabels + [.country]
        }
        
        self.preferesAscendingAddressScope = preferesAscendingAddressScope
    }
    
    var debugDescription: String {
        return "alpha3Code: \(alpha3Code), name: \(englishName)"
    }
        
    static let Afghanistan = Country(alpha3Code: "AFG", englishName: "Afghanistan", alpha2Code: "AF", addressLabels: AddressLabel.cityOnly)
    static let Aland_Islands = Country(alpha3Code: "ALA", englishName: "Åland Islands", alpha2Code: "AX")
    static let Albania = Country(alpha3Code: "ALB", englishName: "Albania", alpha2Code: "AL", addressLabels: AddressLabel.cityOnly)
    static let Algeria = Country(alpha3Code: "DZA", englishName: "Algeria", alpha2Code: "DZ", addressLabels: AddressLabel.cityAndPostal)
    static let American_Samoa = Country(alpha3Code: "ASM", englishName: "American Samoa", alpha2Code: "AS", addressLabels: [.street1, .street2, .city, .state, .zipCode])
    static let Andorra = Country(alpha3Code: "AND", englishName: "Andorra", alpha2Code: "AD", addressLabels: AddressLabel.cityAndPostal)
    static let Angola = Country(alpha3Code: "AGO", englishName: "Angola", alpha2Code: "AO", addressLabels: AddressLabel.cityOnly)
    static let Anguilla = Country(alpha3Code: "AIA", englishName: "Anguilla", alpha2Code: "AI", addressLabels: [.street1, .street2, .district])
    static let Antarctica = Country(alpha3Code: "ATA", englishName: "Antarctica", alpha2Code: "AQ")
    static let Antigua_and_Barbuda = Country(alpha3Code: "ATG", englishName: "Antigua and Barbuda", alpha2Code: "AG", addressLabels: AddressLabel.cityOnly)
    static let Argentina = Country(alpha3Code: "ARG", englishName: "Argentina", alpha2Code: "AR", addressLabels: AddressLabel.defaultList)
    static let Armenia = Country(alpha3Code: "ARM", englishName: "Armenia", alpha2Code: "AM", addressLabels: AddressLabel.cityAndPostal)
    static let Aruba = Country(alpha3Code: "ABW", englishName: "Aruba", alpha2Code: "AW", addressLabels: AddressLabel.cityOnly)
    static let Australia = Country(alpha3Code: "AUS", englishName: "Australia", alpha2Code: "AU", addressLabels: [.street1, .street2, .suburb, .state, .postalCode])
    static let Austria = Country(alpha3Code: "AUT", englishName: "Austria", alpha2Code: "AT", addressLabels: AddressLabel.cityAndPostal)
    static let Azerbaijan = Country(alpha3Code: "AZE", englishName: "Azerbaijan", alpha2Code: "AZ", addressLabels: AddressLabel.cityAndPostal)
    static let Bahamas = Country(alpha3Code: "BHS", englishName: "Bahamas", alpha2Code: "BS", addressLabels: [.street1, .street2, .city, .island])
    static let Bahrain = Country(alpha3Code: "BHR", englishName: "Bahrain", alpha2Code: "BH", addressLabels: AddressLabel.cityAndPostal)
    static let Bangladesh = Country(alpha3Code: "BGD", englishName: "Bangladesh", alpha2Code: "BD", addressLabels: AddressLabel.cityAndPostal)
    static let Barbados = Country(alpha3Code: "BRB", englishName: "Barbados", alpha2Code: "BB", addressLabels: AddressLabel.cityOnly)
    static let Belarus = Country(alpha3Code: "BLR", englishName: "Belarus", alpha2Code: "BY", addressLabels: AddressLabel.defaultList)
    static let Belgium = Country(alpha3Code: "BEL", englishName: "Belgium", alpha2Code: "BE", addressLabels: AddressLabel.cityAndPostal)
    static let Belize = Country(alpha3Code: "BLZ", englishName: "Belize", alpha2Code: "BZ", addressLabels: [.street1, .street2, .city, .province])
    static let Benin = Country(alpha3Code: "BEN", englishName: "Benin", alpha2Code: "BJ", addressLabels: AddressLabel.cityOnly)
    static let Bermuda = Country(alpha3Code: "BMU", englishName: "Bermuda", alpha2Code: "BM", addressLabels: AddressLabel.cityAndPostal)
    static let Bhutan = Country(alpha3Code: "BTN", englishName: "Bhutan", alpha2Code: "BT", addressLabels: AddressLabel.cityOnly)
    static let Bolivia = Country(alpha3Code: "BOL", englishName: "Bolivia", alpha2Code: "BO", addressLabels: AddressLabel.cityAndPostal)
    static let Bonaire_Sint_Eustatius_and_Saba = Country(alpha3Code: "BES", englishName: "Bonaire, Sint Eustatius and Saba", alpha2Code: "BQ", addressLabels: [.street1, .street2, .city, .island])
    static let Bosnia_and_Herzegovina = Country(alpha3Code: "BIH", englishName: "Bosnia and Herzegovina", alpha2Code: "BA", addressLabels: AddressLabel.cityAndPostal)
    static let Botswana = Country(alpha3Code: "BWA", englishName: "Botswana", alpha2Code: "BW", addressLabels: AddressLabel.cityOnly)
    static let Bouvet_Island = Country(alpha3Code: "BVT", englishName: "Bouvet Island", alpha2Code: "BV")
    static let Brazil = Country(alpha3Code: "BRA", englishName: "Brazil", alpha2Code: "BR", addressLabels: [.street1, .street2, .neighborhood, .city, .state, .postalCode])
    static let British_Indian_Ocean_Territory = Country(alpha3Code: "IOT", englishName: "British Indian Ocean Territory", alpha2Code: "IO")
    static let Brunei = Country(alpha3Code: "BRN", englishName: "Brunei Darussalam", alpha2Code: "BN", addressLabels: AddressLabel.cityAndPostal)
    static let Bulgaria = Country(alpha3Code: "BGR", englishName: "Bulgaria", alpha2Code: "BG", addressLabels: AddressLabel.cityAndPostal)
    static let Burkina_Faso = Country(alpha3Code: "BFA", englishName: "Burkina Faso", alpha2Code: "BF", addressLabels: AddressLabel.cityAndPostal)
    static let Burundi = Country(alpha3Code: "BDI", englishName: "Burundi", alpha2Code: "BI", addressLabels: AddressLabel.cityOnly)
    static let Cape_Verde = Country(alpha3Code: "CPV", englishName: "Cape Verde", alpha2Code: "CV", addressLabels: AddressLabel.cityAndPostal)
    static let Cambodia = Country(alpha3Code: "KHM", englishName: "Cambodia", alpha2Code: "KH", addressLabels: AddressLabel.cityAndPostal)
    static let Cameroon = Country(alpha3Code: "CMR", englishName: "Cameroon", alpha2Code: "CM", addressLabels: AddressLabel.cityOnly)
    static let Canada = Country(alpha3Code: "CAN", englishName: "Canada", alpha2Code: "CA", addressLabels: AddressLabel.defaultList)
    static let Cayman_Islands = Country(alpha3Code: "CYM", englishName: "Cayman Islands", alpha2Code: "KY", addressLabels: [.street1, .street2, .island])
    static let Central_African_Republic = Country(alpha3Code: "CAF", englishName: "Central African Republic", alpha2Code: "CF", addressLabels: AddressLabel.cityOnly)
    static let Chad = Country(alpha3Code: "TCD", englishName: "Chad", alpha2Code: "TD", addressLabels: AddressLabel.cityOnly)
    static let Chile = Country(alpha3Code: "CHL", englishName: "Chile", alpha2Code: "CL", addressLabels: AddressLabel.cityAndPostal)
    static let China = Country(alpha3Code: "CHN", englishName: "China", alpha2Code: "CN", addressLabels: [.street1, .street2, .district, .city, .province, .postalCode], preferesAscendingAddressScope: false)
    static let Christmas_Island = Country(alpha3Code: "CXR", englishName: "Christmas Island", alpha2Code: "CX")
    static let Cocos_Islands = Country(alpha3Code: "CCK", englishName: "Cocos Islands", alpha2Code: "CC")
    static let Colombia = Country(alpha3Code: "COL", englishName: "Colombia", alpha2Code: "CO", addressLabels: [.street1, .street2, .city, .department, .postalCode])
    static let Comoros = Country(alpha3Code: "COM", englishName: "Comoros", alpha2Code: "KM", addressLabels: AddressLabel.cityOnly)
    static let Congo_Democratic_Republic = Country(alpha3Code: "COD", englishName: "Congo Democratic Republic", alpha2Code: "CD", addressLabels: AddressLabel.cityOnly)
    static let Congo = Country(alpha3Code: "COG", englishName: "Congo", alpha2Code: "CG", addressLabels: AddressLabel.cityAndPostal)
    static let Cook_Islands = Country(alpha3Code: "COK", englishName: "Cook Islands", alpha2Code: "CK", addressLabels: [.street1, .street2, .island])
    static let Costa_Rica = Country(alpha3Code: "CRI", englishName: "Costa Rica", alpha2Code: "CR", addressLabels: AddressLabel.cityAndPostal)
    static let Cote_d_Ivoire = Country(alpha3Code: "CIV", englishName: "Côte d'Ivoire", alpha2Code: "CI", addressLabels: AddressLabel.cityAndPostal)
    static let Croatia = Country(alpha3Code: "HRV", englishName: "Croatia", alpha2Code: "HR", addressLabels: AddressLabel.cityAndPostal)
    static let Cuba = Country(alpha3Code: "CUB", englishName: "Cuba", alpha2Code: "CU", addressLabels: AddressLabel.cityAndPostal)
    static let Curacao = Country(alpha3Code: "CUW", englishName: "Curaçao", alpha2Code: "CW", addressLabels: AddressLabel.cityOnly)
    static let Cyprus = Country(alpha3Code: "CYP", englishName: "Cyprus", alpha2Code: "CY", addressLabels: AddressLabel.cityAndPostal)
    static let Czechia = Country(alpha3Code: "CZE", englishName: "Czechia", alpha2Code: "CZ", addressLabels: AddressLabel.cityAndPostal)
    static let Denmark = Country(alpha3Code: "DNK", englishName: "Denmark", alpha2Code: "DK", addressLabels: AddressLabel.cityAndPostal)
    static let Djibouti = Country(alpha3Code: "DJI", englishName: "Djibouti", alpha2Code: "DJ", addressLabels: AddressLabel.cityOnly)
    static let Dominica = Country(alpha3Code: "DMA", englishName: "Dominica", alpha2Code: "DM", addressLabels: AddressLabel.cityOnly)
    static let Dominican_Republic = Country(alpha3Code: "DOM", englishName: "Dominican Republic", alpha2Code: "DO", addressLabels: [.street1, .street2, .postalDistrict, .postalCode, .city])
    static let Ecuador = Country(alpha3Code: "ECU", englishName: "Ecuador", alpha2Code: "EC", addressLabels: AddressLabel.cityAndPostal)
    static let Egypt = Country(alpha3Code: "EGY", englishName: "Egypt", alpha2Code: "EG", addressLabels: [.street1, .street2, .district, .governorate])
    static let El_Salvador = Country(alpha3Code: "SLV", englishName: "El Salvador", alpha2Code: "SV", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    static let Equatorial_Guinea = Country(alpha3Code: "GNQ", englishName: "Equatorial Guinea", alpha2Code: "GQ", addressLabels: AddressLabel.cityOnly)
    static let Eritrea = Country(alpha3Code: "ERI", englishName: "Eritrea", alpha2Code: "ER", addressLabels: AddressLabel.cityOnly)
    static let Estonia = Country(alpha3Code: "EST", englishName: "Estonia", alpha2Code: "EE", addressLabels: AddressLabel.cityAndPostal)
    static let Ethiopia = Country(alpha3Code: "ETH", englishName: "Ethiopia", alpha2Code: "ET", addressLabels: AddressLabel.cityAndPostal)
    static let Falkland_Islands = Country(alpha3Code: "FLK", englishName: "Falkland Islands", alpha2Code: "FK", addressLabels: AddressLabel.cityAndPostal)
    static let Faroe_Islands = Country(alpha3Code: "FRO", englishName: "Faroe Islands", alpha2Code: "FO", addressLabels: AddressLabel.cityAndPostal)
    static let Fiji = Country(alpha3Code: "FJI", englishName: "Fiji", alpha2Code: "FJ", addressLabels: [.street1, .street2, .city, .island])
    static let Finland = Country(alpha3Code: "FIN", englishName: "Finland", alpha2Code: "FI", addressLabels: AddressLabel.cityAndPostal)
    static let France = Country(alpha3Code: "FRA", englishName: "France", alpha2Code: "FR", addressLabels: AddressLabel.cityAndPostal)
    static let French_Guiana = Country(alpha3Code: "GUF", englishName: "French Guiana", alpha2Code: "GF", addressLabels: AddressLabel.cityAndPostal)
    static let French_Polynesia = Country(alpha3Code: "PYF", englishName: "French Polynesia", alpha2Code: "PF", addressLabels: [.street1, .street2, .postalCode, .city, .island])
    static let French_Southern_Territories = Country(alpha3Code: "ATF", englishName: "French Southern Territories", alpha2Code: "TF")
    static let Gabon = Country(alpha3Code: "GAB", englishName: "Gabon", alpha2Code: "GA", addressLabels: AddressLabel.cityAndPostal)
    static let Gambia = Country(alpha3Code: "GMB", englishName: "Gambia", alpha2Code: "GM", addressLabels: AddressLabel.cityOnly)
    static let Georgia = Country(alpha3Code: "GEO", englishName: "Georgia", alpha2Code: "GE", addressLabels: AddressLabel.cityAndPostal)
    static let Germany = Country(alpha3Code: "DEU", englishName: "Germany", alpha2Code: "DE", addressLabels: AddressLabel.cityAndPostal)
    static let Ghana = Country(alpha3Code: "GHA", englishName: "Ghana", alpha2Code: "GH", addressLabels: AddressLabel.cityOnly)
    static let Gibraltar = Country(alpha3Code: "GIB", englishName: "Gibraltar", alpha2Code: "GI", addressLabels: AddressLabel.cityAndPostal)
    static let Greece = Country(alpha3Code: "GRC", englishName: "Greece", alpha2Code: "GR", addressLabels: AddressLabel.cityAndPostal)
    static let Greenland = Country(alpha3Code: "GRL", englishName: "Greenland", alpha2Code: "GL", addressLabels: AddressLabel.cityAndPostal)
    static let Grenada = Country(alpha3Code: "GRD", englishName: "Grenada", alpha2Code: "GD", addressLabels: AddressLabel.cityOnly)
    static let Guadeloupe = Country(alpha3Code: "GLP", englishName: "Guadeloupe", alpha2Code: "GP", addressLabels: AddressLabel.cityAndPostal)
    static let Guam = Country(alpha3Code: "GUM", englishName: "Guam", alpha2Code: "GU", addressLabels: [.street1, .street2, .city, .state, .zipCode])
    static let Guatemala = Country(alpha3Code: "GTM", englishName: "Guatemala", alpha2Code: "GT", addressLabels: AddressLabel.cityAndPostal)
    static let Guernsey = Country(alpha3Code: "GGY", englishName: "Guernsey", alpha2Code: "GG")
    static let Guinea = Country(alpha3Code: "GIN", englishName: "Guinea", alpha2Code: "GN", addressLabels: AddressLabel.cityAndPostal)
    static let Guinea_Bissau = Country(alpha3Code: "GNB", englishName: "Guinea-Bissau", alpha2Code: "GW", addressLabels: AddressLabel.cityAndPostal)
    static let Guyana = Country(alpha3Code: "GUY", englishName: "Guyana", alpha2Code: "GY", addressLabels: AddressLabel.cityOnly)
    static let Haiti = Country(alpha3Code: "HTI", englishName: "Haiti", alpha2Code: "HT", addressLabels: AddressLabel.cityAndPostal)
    static let Heard_Island_and_McDonald_Islands = Country(alpha3Code: "HMD", englishName: "Heard_Island_and_McDonald_Islands", alpha2Code: "HM")
    static let Vatican = Country(alpha3Code: "VAT", englishName: "Holy See", alpha2Code: "VA", addressLabels: AddressLabel.cityAndPostal)
    static let Honduras = Country(alpha3Code: "HND", englishName: "Honduras", alpha2Code: "HN", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    static let Hong_Kong = Country(alpha3Code: "HKG", englishName: "Hong Kong", alpha2Code: "HK", addressLabels: [.street1, .street2, .region, .district], preferesAscendingAddressScope: false)
    static let Hungary = Country(alpha3Code: "HUN", englishName: "Hungary", alpha2Code: "HU", addressLabels: AddressLabel.cityAndPostal, preferesAscendingAddressScope: false)
    static let Iceland = Country(alpha3Code: "ISL", englishName: "Iceland", alpha2Code: "IS", addressLabels: AddressLabel.cityAndPostal)
    static let India = Country(alpha3Code: "IND", englishName: "India", alpha2Code: "IN", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    static let Indonesia = Country(alpha3Code: "IDN", englishName: "Indonesia", alpha2Code: "ID", addressLabels: AddressLabel.defaultList)
    static let Iran = Country(alpha3Code: "IRN", englishName: "Iran", alpha2Code: "IR", addressLabels: AddressLabel.cityAndPostal)
    static let Iraq = Country(alpha3Code: "IRQ", englishName: "Iraq", alpha2Code: "IQ", addressLabels: AddressLabel.cityAndPostal)
    static let Ireland = Country(alpha3Code: "IRL", englishName: "Ireland", alpha2Code: "IE", addressLabels: [.street1, .street2, .city, .county, .postalCode])
    static let Isle_of_Man = Country(alpha3Code: "IMN", englishName: "Isle of Man", alpha2Code: "IM", addressLabels: AddressLabel.cityAndPostal)
    static let Israel = Country(alpha3Code: "ISR", englishName: "Israel", alpha2Code: "IL", addressLabels: AddressLabel.cityAndPostal)
    static let Italy = Country(alpha3Code: "ITA", englishName: "Italy", alpha2Code: "IT", addressLabels: AddressLabel.defaultList)
    static let Jamaica = Country(alpha3Code: "JAM", englishName: "Jamaica", alpha2Code: "JM", addressLabels: AddressLabel.cityAndPostal)
    static let Japan = Country(alpha3Code: "JPN", englishName: "Japan", alpha2Code: "JP", addressLabels: [.street1, .street2, .city, .county, .prefecture, .postalCode], preferesAscendingAddressScope: false)
    static let Jersey = Country(alpha3Code: "JEY", englishName: "Jersey", alpha2Code: "JE")
    static let Jordan = Country(alpha3Code: "JOR", englishName: "Jordan", alpha2Code: "JO", addressLabels: [.street1, .street2, .city, .postalDistrict, .postalCode])
    static let Kazakhstan = Country(alpha3Code: "KAZ", englishName: "Kazakhstan", alpha2Code: "KZ", addressLabels: [.street1, .street2, .city, .postalDistrict, .postalCode])
    static let Kenya = Country(alpha3Code: "KEN", englishName: "Kenya", alpha2Code: "KE", addressLabels: AddressLabel.cityAndPostal)
    static let Kiribati = Country(alpha3Code: "KIR", englishName: "Kiribati", alpha2Code: "KI", addressLabels: [.street1, .street2, .city, .island])
    static let Kuwait = Country(alpha3Code: "KWT", englishName: "Kuwait", alpha2Code: "KW", addressLabels: AddressLabel.defaultList)
    static let Kyrgyzstan = Country(alpha3Code: "KGZ", englishName: "Kyrgyzstan", alpha2Code: "KG", addressLabels: AddressLabel.cityAndPostal, preferesAscendingAddressScope: false)
    static let Lao = Country(alpha3Code: "LAO", englishName: "Lao", alpha2Code: "LA", addressLabels: AddressLabel.cityAndPostal)
    static let Latvia = Country(alpha3Code: "LVA", englishName: "Latvia", alpha2Code: "LV", addressLabels: AddressLabel.cityAndPostal)
    static let Lebanon = Country(alpha3Code: "LBN", englishName: "Lebanon", alpha2Code: "LB", addressLabels: AddressLabel.cityAndPostal)
    static let Lesotho = Country(alpha3Code: "LSO", englishName: "Lesotho", alpha2Code: "LS", addressLabels: AddressLabel.cityAndPostal)
    static let Liberia = Country(alpha3Code: "LBR", englishName: "Liberia", alpha2Code: "LR", addressLabels: AddressLabel.cityAndPostal)
    static let Libya = Country(alpha3Code: "LBY", englishName: "Libya", alpha2Code: "LY", addressLabels: AddressLabel.cityOnly)
    static let Liechtenstein = Country(alpha3Code: "LIE", englishName: "Liechtenstein", alpha2Code: "LI", addressLabels: AddressLabel.cityAndPostal)
    static let Lithuania = Country(alpha3Code: "LTU", englishName: "Lithuania", alpha2Code: "LT", addressLabels: AddressLabel.cityAndPostal)
    static let Luxembourg = Country(alpha3Code: "LUX", englishName: "Luxembourg", alpha2Code: "LU", addressLabels: AddressLabel.cityAndPostal)
    static let Macao = Country(alpha3Code: "MAC", englishName: "Macao", alpha2Code: "MO", addressLabels:[.street1, .street2, .district, .city], preferesAscendingAddressScope: false)
    static let North_Macedonia = Country(alpha3Code: "MKD", englishName: "North Macedonia", alpha2Code: "MK", addressLabels: AddressLabel.cityAndPostal)
    static let Madagascar = Country(alpha3Code: "MDG", englishName: "Madagascar", alpha2Code: "MG", addressLabels: AddressLabel.cityAndPostal)
    static let Malawi = Country(alpha3Code: "MWI", englishName: "Malawi", alpha2Code: "MW", addressLabels: AddressLabel.cityAndPostal)
    static let Malaysia = Country(alpha3Code: "MYS", englishName: "Malaysia", alpha2Code: "MY", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    static let Maldives = Country(alpha3Code: "MDV", englishName: "Maldives", alpha2Code: "MV", addressLabels: AddressLabel.cityAndPostal)
    static let Mali = Country(alpha3Code: "MLI", englishName: "Mali", alpha2Code: "ML", addressLabels: AddressLabel.cityOnly)
    static let Malta = Country(alpha3Code: "MLT", englishName: "Malta", alpha2Code: "MT", addressLabels: AddressLabel.cityAndPostal)
    static let Marshall_Islands = Country(alpha3Code: "MHL", englishName: "Marshall Islands", alpha2Code: "MH", addressLabels: AddressLabel.cityAndPostal)
    static let Martinique = Country(alpha3Code: "MTQ", englishName: "Martinique", alpha2Code: "MQ", addressLabels: AddressLabel.cityAndPostal)
    static let Mauritania = Country(alpha3Code: "MRT", englishName: "Mauritania", alpha2Code: "MR", addressLabels: AddressLabel.cityOnly)
    static let Mauritius = Country(alpha3Code: "MUS", englishName: "Mauritius", alpha2Code: "MU", addressLabels: AddressLabel.cityAndPostal)
    static let Mayotte = Country(alpha3Code: "MYT", englishName: "Mayotte", alpha2Code: "YT", addressLabels: AddressLabel.cityAndPostal)
    static let Mexico = Country(alpha3Code: "MEX", englishName: "Mexico", alpha2Code: "MX", addressLabels: [.street1, .street2, .city, .postalCode, .postalCode])
    static let Micronesia = Country(alpha3Code: "FSM", englishName: "Micronesia", alpha2Code: "FM", addressLabels: [.street1, .street2, .city, .state, .zipCode])
    static let Moldova = Country(alpha3Code: "MDA", englishName: "Moldova", alpha2Code: "MD", addressLabels: AddressLabel.cityAndPostal)
    static let Monaco = Country(alpha3Code: "MCO", englishName: "Monaco", alpha2Code: "MC", addressLabels: AddressLabel.cityAndPostal)
    static let Mongolia = Country(alpha3Code: "MNG", englishName: "Mongolia", alpha2Code: "MN", addressLabels: AddressLabel.cityAndPostal)
    static let Montenegro = Country(alpha3Code: "MNE", englishName: "Montenegro", alpha2Code: "ME", addressLabels: AddressLabel.cityAndPostal)
    static let Montserrat = Country(alpha3Code: "MSR", englishName: "Montserrat", alpha2Code: "MS", addressLabels: AddressLabel.cityAndPostal)
    static let Morocco = Country(alpha3Code: "MAR", englishName: "Morocco", alpha2Code: "MA", addressLabels: AddressLabel.cityAndPostal)
    static let Mozambique = Country(alpha3Code: "MOZ", englishName: "Mozambique", alpha2Code: "MZ", addressLabels: AddressLabel.defaultList)
    static let Myanmar = Country(alpha3Code: "MMR", englishName: "Myanmar", alpha2Code: "MM", addressLabels: AddressLabel.cityAndPostal)
    static let Namibia = Country(alpha3Code: "NAM", englishName: "Namibia", alpha2Code: "NA", addressLabels: AddressLabel.cityOnly)
    static let Nauru = Country(alpha3Code: "NRU", englishName: "Nauru", alpha2Code: "NR", addressLabels: [.street1, .street2, .district])
    static let Nepal = Country(alpha3Code: "NPL", englishName: "Nepal", alpha2Code: "NP", addressLabels: AddressLabel.cityAndPostal)
    static let Netherlands = Country(alpha3Code: "NLD", englishName: "Netherlands", alpha2Code: "NL", addressLabels: AddressLabel.cityAndPostal)
    static let New_Caledonia = Country(alpha3Code: "NCL", englishName: "New Caledonia", alpha2Code: "NC", addressLabels: AddressLabel.cityAndPostal)
    static let New_Zealand = Country(alpha3Code: "NZL", englishName: "New Zealand", alpha2Code: "NZ", addressLabels: [.street1, .street2, .suburb, .city, .postalCode])
    static let Nicaragua = Country(alpha3Code: "NIC", englishName: "Nicaragua", alpha2Code: "NI", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    static let Niger = Country(alpha3Code: "NER", englishName: "Niger", alpha2Code: "NE", addressLabels: AddressLabel.cityAndPostal)
    static let Nigeria = Country(alpha3Code: "NGA", englishName: "Nigeria", alpha2Code: "NG", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    static let Niue = Country(alpha3Code: "NIU", englishName: "Niue", alpha2Code: "NU")
    static let Norfolk_Island = Country(alpha3Code: "NFK", englishName: "Norfolk Island", alpha2Code: "NF")
    static let North_Korea = Country(alpha3Code: "PRK", englishName: "North Korea", alpha2Code: "KP", addressLabels: [.street1, .street2, .city, .province], preferesAscendingAddressScope: false)
    static let Northern_Mariana_Islands = Country(alpha3Code: "MNP", englishName: "Northern Mariana Islands", alpha2Code: "MP")
    static let Norway = Country(alpha3Code: "NOR", englishName: "Norway", alpha2Code: "NO", addressLabels: AddressLabel.cityAndPostal)
    static let Oman = Country(alpha3Code: "OMN", englishName: "Oman", alpha2Code: "OM", addressLabels: AddressLabel.defaultList)
    static let Pakistan = Country(alpha3Code: "PAK", englishName: "Pakistan", alpha2Code: "PK", addressLabels: AddressLabel.cityAndPostal)
    static let Palau = Country(alpha3Code: "PLW", englishName: "Palau", alpha2Code: "PW", addressLabels: AddressLabel.usStyle)
    static let Palestine = Country(alpha3Code: "PSE", englishName: "Palestine", alpha2Code: "PS", addressLabels: AddressLabel.cityAndPostal)
    static let Panama = Country(alpha3Code: "PAN", englishName: "Panama", alpha2Code: "PA", addressLabels: AddressLabel.defaultList)
    static let Papua_New_Guinea = Country(alpha3Code: "PNG", englishName: "Papua New Guinea", alpha2Code: "PG", addressLabels: AddressLabel.defaultList)
    static let Paraguay = Country(alpha3Code: "PRY", englishName: "Paraguay", alpha2Code: "PY", addressLabels: AddressLabel.cityAndPostal)
    static let Peru = Country(alpha3Code: "PER", englishName: "Peru", alpha2Code: "PE", addressLabels: AddressLabel.cityAndPostal)
    static let Philippines = Country(alpha3Code: "PHL", englishName: "Philippines", alpha2Code: "PH", addressLabels: [.street1, .street2, .district, .city, .postalCode])
    static let Pitcairn = Country(alpha3Code: "PCN", englishName: "Pitcairn", alpha2Code: "PN")
    static let Poland = Country(alpha3Code: "POL", englishName: "Poland", alpha2Code: "PL", addressLabels: AddressLabel.cityAndPostal)
    static let Portugal = Country(alpha3Code: "PRT", englishName: "Portugal", alpha2Code: "PT", addressLabels: AddressLabel.cityAndPostal)
    static let Puerto_Rico = Country(alpha3Code: "PRI", englishName: "Puerto Rico", alpha2Code: "PR", addressLabels: AddressLabel.usStyle)
    static let Qatar = Country(alpha3Code: "QAT", englishName: "Qatar", alpha2Code: "QA", addressLabels: AddressLabel.cityAndPostal)
    static let Reunion = Country(alpha3Code: "REU", englishName: "Réunion", alpha2Code: "RE", addressLabels: AddressLabel.cityAndPostal)
    static let Romania = Country(alpha3Code: "ROU", englishName: "Romania", alpha2Code: "RO", addressLabels: AddressLabel.cityAndPostal)
    static let Russia = Country(alpha3Code: "RUS", englishName: "Russian Federation", alpha2Code: "RU", addressLabels: [.street1, .street2, .city, .subjectOfFederation, .postalCode])
    static let Rwanda = Country(alpha3Code: "RWA", englishName: "Rwanda", alpha2Code: "RW", addressLabels: AddressLabel.cityOnly)
    static let Saint_Barthelemy = Country(alpha3Code: "BLM", englishName: "Saint Barthélemy", alpha2Code: "BL", addressLabels: AddressLabel.cityAndPostal)
    static let Saint_Helena = Country(alpha3Code: "SHN", englishName: "Saint Helena", alpha2Code: "SH", addressLabels: AddressLabel.cityAndPostal)
    static let Saint_Kitts_and_Nevis = Country(alpha3Code: "KNA", englishName: "Saint Kitts and Nevis", alpha2Code: "KN", addressLabels: [.street1, .street2, .postalCode, .city, .island])
    static let Saint_Lucia = Country(alpha3Code: "LCA", englishName: "Saint Lucia", alpha2Code: "LC", addressLabels: AddressLabel.cityOnly)
    static let Saint_Martin = Country(alpha3Code: "MAF", englishName: "Saint Martin", alpha2Code: "MF", addressLabels: AddressLabel.cityAndPostal)
    static let Saint_Pierre_and_Miquelon = Country(alpha3Code: "SPM", englishName: "Saint Pierre and Miquelon", alpha2Code: "PM")
    static let Saint_Vincent_and_the_Grenadines = Country(alpha3Code: "VCT", englishName: "Saint Vincent and the Grenadines", alpha2Code: "VC", addressLabels: AddressLabel.cityOnly)
    static let Samoa = Country(alpha3Code: "WSM", englishName: "Samoa", alpha2Code: "WS", addressLabels: AddressLabel.cityOnly)
    static let San_Marino = Country(alpha3Code: "SMR", englishName: "San Marino", alpha2Code: "SM", addressLabels: AddressLabel.defaultList)
    static let Sao_Tome_and_Principe = Country(alpha3Code: "STP", englishName: "Sao Tome and Principe", alpha2Code: "ST", addressLabels: AddressLabel.cityOnly)
    static let Saudi_Arabia = Country(alpha3Code: "SAU", englishName: "Saudi Arabia", alpha2Code: "SA", addressLabels: [.street1, .street2, .district, .city, .postalCode])
    static let Senegal = Country(alpha3Code: "SEN", englishName: "Senegal", alpha2Code: "SN", addressLabels: AddressLabel.cityAndPostal)
    static let Serbia = Country(alpha3Code: "SRB", englishName: "Serbia", alpha2Code: "RS", addressLabels: AddressLabel.cityAndPostal)
    static let Seychelles = Country(alpha3Code: "SYC", englishName: "Seychelles", alpha2Code: "SC", addressLabels: AddressLabel.cityOnly)
    static let Sierra_Leone = Country(alpha3Code: "SLE", englishName: "Sierra Leone", alpha2Code: "SL", addressLabels: AddressLabel.cityOnly)
    static let Singapore = Country(alpha3Code: "SGP", englishName: "Singapore", alpha2Code: "SG", addressLabels: AddressLabel.cityAndPostal)
    static let Sint_Maarten = Country(alpha3Code: "SXM", englishName: "Sint Maarten", alpha2Code: "SX", addressLabels: AddressLabel.cityOnly)
    static let Slovakia = Country(alpha3Code: "SVK", englishName: "Slovakia", alpha2Code: "SK", addressLabels: AddressLabel.cityAndPostal)
    static let Slovenia = Country(alpha3Code: "SVN", englishName: "Slovenia", alpha2Code: "SI", addressLabels: AddressLabel.cityAndPostal)
    static let Solomon_Islands = Country(alpha3Code: "SLB", englishName: "Solomon Islands", alpha2Code: "SB", addressLabels: AddressLabel.cityOnly)
    static let Somalia = Country(alpha3Code: "SOM", englishName: "Somalia", alpha2Code: "SO", addressLabels: [.street1, .street2, .city, .region, .postalCode])
    static let South_Africa = Country(alpha3Code: "ZAF", englishName: "South Africa", alpha2Code: "ZA", addressLabels: AddressLabel.defaultList)
    static let South_Georgia_and_Sandwich_Islands = Country(alpha3Code: "SGS", englishName: "South_Georgia_and_Sandwich_Islands", alpha2Code: "GS", addressLabels: AddressLabel.cityAndPostal)
    static let South_Korea = Country(alpha3Code: "KOR", englishName: "South Korea", alpha2Code: "KR", addressLabels: [.postalCode, .province, .city, .street1, .street2], preferesAscendingAddressScope: false)
    static let South_Sudan = Country(alpha3Code: "SSD", englishName: "South Sudan", alpha2Code: "SS", addressLabels: AddressLabel.cityAndPostal)
    static let Spain = Country(alpha3Code: "ESP", englishName: "Spain", alpha2Code: "ES", addressLabels: AddressLabel.defaultList)
    static let Sri_Lanka = Country(alpha3Code: "LKA", englishName: "Sri Lanka", alpha2Code: "LK", addressLabels: AddressLabel.cityAndPostal)
    static let Sudan = Country(alpha3Code: "SDN", englishName: "Sudan", alpha2Code: "SD", addressLabels: AddressLabel.cityAndPostal)
    static let Suriname = Country(alpha3Code: "SUR", englishName: "Suriname", alpha2Code: "SR", addressLabels: [.street1, .street2, .city, .district])
    static let Svalbard_and_Jan_Mayen = Country(alpha3Code: "SJM", englishName: "Svalbard and Jan Mayen", alpha2Code: "SJ")
    static let Swaziland = Country(alpha3Code: "SWZ", englishName: "Swaziland", alpha2Code: "SZ", addressLabels: AddressLabel.cityAndPostal)
    static let Sweden = Country(alpha3Code: "SWE", englishName: "Sweden", alpha2Code: "SE", addressLabels: AddressLabel.cityAndPostal)
    static let Switzerland = Country(alpha3Code: "CHE", englishName: "Switzerland", alpha2Code: "CH", addressLabels: AddressLabel.cityAndPostal)
    static let Syria = Country(alpha3Code: "SYR", englishName: "Syrian Arab Republic", alpha2Code: "SY", addressLabels: AddressLabel.cityAndPostal)
    static let Taiwan = Country(alpha3Code: "TWN", englishName: "Taiwan", alpha2Code: "TW", addressLabels: [.zipCode, .county, .township, .street1, .street2], preferesAscendingAddressScope: false)
    static let Tajikistan = Country(alpha3Code: "TJK", englishName: "Tajikistan", alpha2Code: "TJ", addressLabels: AddressLabel.cityAndPostal )
    static let Tanzania = Country(alpha3Code: "TZA", englishName: "Tanzania", alpha2Code: "TZ", addressLabels: AddressLabel.cityOnly)
    static let Thailand = Country(alpha3Code: "THA", englishName: "Thailand", alpha2Code: "TH", addressLabels: [.street1, .street2, .district, .province, .postalCode])
    static let Timor_Leste = Country(alpha3Code: "TLS", englishName: "Timor-Leste", alpha2Code: "TL", addressLabels: AddressLabel.cityOnly)
    static let Togo = Country(alpha3Code: "TGO", englishName: "Togo", alpha2Code: "TG", addressLabels: AddressLabel.cityOnly)
    static let Tokelau = Country(alpha3Code: "TKL", englishName: "Tokelau", alpha2Code: "TK")
    static let Tonga = Country(alpha3Code: "TON", englishName: "Tonga", alpha2Code: "TO", addressLabels: AddressLabel.cityOnly)
    static let Trinidad_and_Tobago = Country(alpha3Code: "TTO", englishName: "Trinidad and Tobago", alpha2Code: "TT", addressLabels: AddressLabel.cityOnly)
    static let Tunisia = Country(alpha3Code: "TUN", englishName: "Tunisia", alpha2Code: "TN", addressLabels: AddressLabel.cityAndPostal)
    static let Turkey = Country(alpha3Code: "TUR", englishName: "Turkey", alpha2Code: "TR", addressLabels: [.street1, .street2, .postalCode, .district, .city])
    static let Turkmenistan = Country(alpha3Code: "TKM", englishName: "Turkmenistan", alpha2Code: "TM", addressLabels: AddressLabel.cityAndPostal)
    static let Turks_and_Caicos_Islands = Country(alpha3Code: "TCA", englishName: "Turks and Caicos Islands", alpha2Code: "TC", addressLabels: [.street1, .street2, .island])
    static let Tuvalu = Country(alpha3Code: "TUV", englishName: "Tuvalu", alpha2Code: "TV", addressLabels: AddressLabel.cityOnly)
    static let United_Kingdom = Country(alpha3Code: "GBR", englishName: "United Kingdom", alpha2Code: "GB", addressLabels: [.street1, .street2, .town, .county, .postalCode])
    static let US_Minor_Outlying_Islands = Country(alpha3Code: "UMI", englishName: "U.S. Minor Outlying Islands", alpha2Code: "UM")
    static let Uganda = Country(alpha3Code: "UGA", englishName: "Uganda", alpha2Code: "UG", addressLabels: AddressLabel.cityOnly)
    static let Ukraine = Country(alpha3Code: "UKR", englishName: "Ukraine", alpha2Code: "UA", addressLabels: AddressLabel.defaultList)
    static let United_Arab_Emirates = Country(alpha3Code: "ARE", englishName: "United Arab Emirates", alpha2Code: "AE", addressLabels: [.street1, .street2, .area, .city])
    static let United_States = Country(alpha3Code: "USA", englishName: "United States", alpha2Code: "US", addressLabels: AddressLabel.usStyle)
    static let Uruguay = Country(alpha3Code: "URY", englishName: "Uruguay", alpha2Code: "UY", addressLabels: [.street1, .street2, .postalCode, .city, .department])
    static let Uzbekistan = Country(alpha3Code: "UZB", englishName: "Uzbekistan", alpha2Code: "UZ", addressLabels: AddressLabel.cityAndPostal)
    static let Vanuatu = Country(alpha3Code: "VUT", englishName: "Vanuatu", alpha2Code: "VU", addressLabels: AddressLabel.cityOnly)
    static let Venezuela = Country(alpha3Code: "VEN", englishName: "Venezuela", alpha2Code: "VE", addressLabels: [.street1, .street2, .city, .postalCode, .state])
    static let Viet_Nam = Country(alpha3Code: "VNM", englishName: "Viet Nam", alpha2Code: "VN", addressLabels: AddressLabel.defaultList)
    static let British_Virgin_Islands = Country(alpha3Code: "VGB", englishName: "Virgin Islands (British)", alpha2Code: "VG", addressLabels: AddressLabel.cityAndPostal)
    static let US_Virgin_Islands = Country(alpha3Code: "VIR", englishName: "Virgin Islands (U.S.)", alpha2Code: "VI", addressLabels: AddressLabel.usStyle)
    static let Wallis_and_Futuna = Country(alpha3Code: "WLF", englishName: "Wallis and Futuna", alpha2Code: "WF")
    static let Western_Sahara = Country(alpha3Code: "ESH", englishName: "Western Sahara", alpha2Code: "EH")
    static let Yemen = Country(alpha3Code: "YEM", englishName: "Yemen", alpha2Code: "YE", addressLabels: AddressLabel.cityAndPostal)
    static let Zambia = Country(alpha3Code: "ZMB", englishName: "Zambia", alpha2Code: "ZM", addressLabels: AddressLabel.cityAndPostal)
    static let Zimbabwe = Country(alpha3Code: "ZWE", englishName: "Zimbabwe", alpha2Code: "ZW", addressLabels: AddressLabel.cityOnly)
    
    
    static let Worldwide = Country(alpha3Code: "WWC", englishName: "Worldwide", alpha2Code: "WW")
    static let Unknown = Country(alpha3Code: "_UK", englishName: "Unknown Country", alpha2Code: "_U")
}

