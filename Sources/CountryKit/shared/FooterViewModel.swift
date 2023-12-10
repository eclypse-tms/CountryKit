//
//  FooterViewModel.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation

public struct FooterViewModel: Hashable, Identifiable {
    /// simple identifier to separate different footers in the same view
    public let id: String
    
    /// the footer text in the footer
    public let footerText: String
    
    init(footerText: String, id: String = UUID().uuidString) {
        self.id = id
        self.footerText = footerText
    }
}
