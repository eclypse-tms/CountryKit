//
//  String+Localize.swift
//  
//
//  Created by eclypse on 12/8/23.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable.strings", bundle: CountryKit.assetBundle, comment: "")
    }

    func localize(with parameters: CVarArg...) -> String {
        return String(format: self.localize(), arguments: parameters)
    }
    
    /// you don't generally call this function directly, it is meant to be called
    /// by another function that takes CVarArg... as arguments
    func localize(using pointerToVarArgs: CVaListPointer) -> String {
        return NSString(format: self.localize(), arguments: pointerToVarArgs) as String
    }
}
