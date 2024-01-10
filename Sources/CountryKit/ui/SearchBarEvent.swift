//
//  SearchBarEvent.swift
//  CountryKit
// 
//  Created by eclypse on 1/3/24.
//

import Foundation

public enum SearchBarEvent: String {
    case toolbarSearchBarTextChanged = "countrykit.app.notification.searchbartextchanged"

    public var name: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}
