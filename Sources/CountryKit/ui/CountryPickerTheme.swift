//
//  CountryPickerTheme.swift
//  CountryKit
// 
//  Created by eclypse on 1/8/24.
//

import UIKit

public struct CountryPickerTheme {
    /// provide a font to match the theme of your app. Otherwise it uses the default OS font
    public var font: UIFont?
    
    /// indicates how the cells should look like when they are selected by the user.
    /// this property is ignored when running in mac catalyst mode and the system
    /// applies a highlight when the cell is selected.
    public var cellSelectionStyle: CountryCellSelectionStyle = .checkMark
    
    /// when the cellSelectionStyle is checkmark, this property applies a tint to the checkmark.
    /// when the cellSelectionStyle is highlight, this property applies a tint to the cell highlight.
    /// If no color is provided, the picker view applies the default system tint color.
    public var selectionTint: UIColor? {
        didSet {
            switch cellSelectionStyle {
            case .checkMark:
                //nothing to do
                break
            case .highlight:
                _isRowSelectionColorPerceivedBright = selectionTint?.isPerceivedBright ?? false
            }
        }
    }
    
    /// used to eliminate subsequent calls to isPerceivedBright
    var _isRowSelectionColorPerceivedBright: Bool = false
    
    /// provide a custom view to appear at the navigation bar's title view.
    /// Navigation bar is hidden when running in catalyst mode.
    public var navigationBarTitleView: UIView?
    
    /// the color to apply to the picker view's non-scrollable header view area
    public var headerBackgroundColor: UIColor?
    
    /// the color to apply to the picker view's non-scrollable footer view area
    public var footerBackgroundColor: UIColor?
    
    /// initializes CountryPickerTheme with default parameters
    public static func `default`() -> CountryPickerTheme {
        return CountryPickerTheme()
    }
    
    /// initializes CountryPickerTheme with default parameters
    public init() {}
}
