//
//  MacConfiguration.swift
//
//
//  Created by eclypse on 1/4/24.
//

import UIKit

public struct MacConfiguration {
    /// title of the done button when running in catalyst mode. 
    /// when left empty localized version of Done will be used.
    public var doneButtonTitle: String?
    
    /// title of the cancel button when running in catalyst mode.
    /// when left empty localized version of Cancel will be used.
    public var cancelButtonTitle: String?
    
    /// background color of the bottom toolbar
    public var bottomToolbarColor: UIColor?
    
    /// the height of each row in the picker UI. defaults to 40.
    public var rowHeight: CGFloat = 40
    
    /// size of the flag in each row. Defaults to 20x20.
    public var flagSize: CGSize = CGSize(width: 20, height: 20)
    
    /// the color to apply when the row is selected
    public var rowSelectionColor: UIColor? {
        didSet {
            _isRowSelectionColorPerceivedBright = rowSelectionColor?.isPerceivedBright ?? false
        }
    }
    
    /// if you are presenting the picker view in a window that already includes a search bar,
    /// turn this flag to false to hide the embedded search bar.
    public var showSearchBar: Bool = true
    
    /// used to eliminate subsequent calls to isPerceivedBright
    var _isRowSelectionColorPerceivedBright: Bool = false
    
    /// initializes MacConfiguration with default parameters
    static public func `default`() -> MacConfiguration {
        MacConfiguration()
    }
    
    /// initializes CountrySelectionConfiguration with default parameters
    public init() {}
}
