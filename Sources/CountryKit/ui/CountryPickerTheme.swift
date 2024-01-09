//
//  CountryPickerTheme.swift
//
//
//  Created by eclypse on 1/8/24.
//

import UIKit

public struct CountryPickerTheme {
    /// provide a font to match the theme of your app. Otherwise it uses the default OS font
    public var font: UIFont?
    
    /// indicates how the cells should look like when they are selected by the user
    /// this property is ignored when running in mac catalyst mode
    public var cellSelectionStyle: CountryCellSelectionStyle = .checkMark
    
    /// provide a custom view to appear at the navigation bar's title view.
    /// Navigation bar is hidden when running in catalyst mode.
    public var navigationBarTitleView: UIView?
    
    /// the color to apply to the picker view's background
    public var backgroundColor: UIColor?
    
    /// the color to apply to the picker view's non-scrollable header view area
    public var headerBackgroundColor: UIColor?
    
    /// the color to apply to the picker view's non-scrollable footer view area
    public var footerBackgroundColor: UIColor?
    
    public init() {}
}
