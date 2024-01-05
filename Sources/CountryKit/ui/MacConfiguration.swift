//
//  MacConfiguration.swift
//
//
//  Created by eclypse on 1/4/24.
//

import UIKit

public struct MacConfiguration {
    /// title of the cancel button when running in catalyst mode
    public var cancelButtonTitle: String?
    
    /// title of the done button when running in catalyst mode
    public var doneButtonTitle: String?
    
    /// background color of the bottom toolbar
    public var bottomToolbarColor: UIColor?
    
    /// the height of each row in the picker UI. defaults to 40.
    public var countryRowHeight: CGFloat = 40
    
    /// size of the flag in each row. Defaults to 20x20.
    public var flagSize: CGSize = CGSize(width: 20, height: 20)
    
    /// initializes MacConfiguration with default parameters
    static public func `default`() -> MacConfiguration {
        MacConfiguration()
    }
    
    /// initializes CountrySelectionConfiguration with default parameters
    public init() {}
}
