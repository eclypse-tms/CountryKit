//
//  String+Parsing.swift
//
//
//  Created by eclypse on 12/29/23.
//

import Foundation

extension String {
    /// used for csv parsing. if the string value is empty string, returns a nil value instead
    var valueOrNil: String? {
        return self.isEmpty ? nil : self
    }
}
