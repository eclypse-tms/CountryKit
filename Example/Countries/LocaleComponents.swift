//
//  LocaleComponents.swift
//  Countries
//
//  Created by eclypse on 12/13/23.
//

import Foundation

struct LocaleComponents: Hashable {
    let identifier: String
    let languageCode: String
    let languageScript: String?
    let regionCode: String
}

enum RecognizedScripts: String {
    /// a script that is used primarily in Europe
    case latin = "Latn"
    
    /// a script that is used primarily in India
    case devanagari = "Deva"
    
    /// a script that is used primarily in Arabian Peninsula
    case arabic = "Arab"
    
    /// a script that is used primarily in India
    case Gurmukhi = "Guru"
    
    /// a script that is used primarily in China, Macao, Singapore & Hong Kong
    case simplifiedHan = "Hans"
    
    /// a script that is used primarily in China, Taiwan, Macao, Singapore & Hong Kong
    case hanTraditional = "Hant"
    
    /// a script that is used primarily in Senegal, Mauritania, Burkina Faso, Liberia,
    /// Cameroon, Niger, Guinea, Nigeria, Guinea-Bissau, Gambia, Ghana, Sierra Leone
    /// for the language Fula
    case adlam = "Adlm"
    
    /// a script that is used primarily in Liberia for the language Vai
    case vai = "Vaii"
    
    /// a script that is used primarily in slavic countries or countries that used to be part of Russia
    case cyrillic = "Cyrl"
    
    /// a script that is used primarily in India for the language Manipuri
    case bangla = "Beng"
    
    /// a script that is used primarily in India for the language Santali
    case olChiki = "Olck"
    
    /// a script that is used primarily in Morocco for the language Tachelhit
    case tifinagh = "Tfng"
    
    /// a script that is used primarily in India for the language Manipuri
    case meiteiMayek = "Mtei"
    
    /// a script that is used primarily in Myanmar and Bangladesh for the language Rohingya
    case hanifiRohingya = "Rohg"
}
