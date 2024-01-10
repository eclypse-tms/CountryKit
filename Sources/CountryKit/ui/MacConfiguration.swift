//
//  MacConfiguration.swift
//  CountryKit
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
    
    /// provide a color to create a separation line between the view and the bottom toolbar
    /// by default this line color is clear.
    public var bottomToolbarSeparatorColor: UIColor?
    
    /// the height of each row in the picker UI. defaults to 40.
    public var rowHeight: CGFloat = 40
    
    /// size of the flag in each row. Defaults to 20x20.
    public var flagSize: CGSize = CGSize(width: 20, height: 20)
    
    /// the color to apply when the cell is selected
    public var cellSelectionColor: UIColor? {
        didSet {
            _isRowSelectionColorPerceivedBright = cellSelectionColor?.isPerceivedBright ?? false
        }
    }
    
    /// if you are presenting the picker view in a window that already includes a search bar,
    /// turn this flag to false to hide the embedded search bar.
    public var showSearchBar: Bool = true
    
    /// provide a custom button to replace the default cancel button provided by the picker view.
    public var customCancelButton: UIButton?
    
    /// provide a custom button to replace the default done button provided by the picker view.
    public var customDoneButton: UIButton?
    
    /// used to eliminate subsequent calls to isPerceivedBright
    var _isRowSelectionColorPerceivedBright: Bool = false
    
    /// initializes MacConfiguration with default parameters
    static public func `default`() -> MacConfiguration {
        MacConfiguration()
    }
    
    /// initializes CountrySelectionConfiguration with default parameters
    public init() {}
}
