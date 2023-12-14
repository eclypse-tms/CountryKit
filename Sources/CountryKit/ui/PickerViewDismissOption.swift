//
//  PickerViewDismissOption.swift
//  CountryKit
//
//  Created by Turker Nessa on 12/14/23.
//

import Foundation

/// Provides options on which navigation bar buttons to display on the Picker View Controller.
/// This is especially useful depending on the UX of your app.
/// If you want to be notified as soon as the user makes a selection on the Picker View Controller,
/// presenting the "Done" button on the trailing (right) side of the navigation bar may be redundant.
/// If you are waiting for user to finish making selections and therefore want to be notified at the
/// end of the selection process, presenting the "Back or Cancel" button on the leading (left) side of the
/// navigation bar may be redundant.
public enum PickerViewDismissOption: Int {
    /// displays the Cancel or Back button that appears on the leading side of the navigation bar (if present).
    /// User has to click this button to dismiss the UI.
    case displayLeadingButtonOnly
    
    /// displays the Done button that appears on the trailing side of the navigation bar (if present).
    /// User has to click this button to dismiss the UI.
    case displayTrailingButtonOnly
    
    /// displays both the Cancel and Done buttons that appears both sides of navigation bar (if present).
    /// User can click either button to dismiss the UI.
    /// Displaying both buttons may be redundant.
    case displayBothButtons
}
