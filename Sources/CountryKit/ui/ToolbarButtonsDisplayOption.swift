//
//  ToolbarButtonsDisplayOption.swift
//  CountryKit
//
//  Created by eclypse on 12/14/23.
//

import Foundation

/**
 Provides options on which navigation bar buttons (or toolbar buttons when running in mac catalyst mode)
 to display on the Picker View Controller.
 
 This is especially useful depending on the UX of your app.
 If you want to be notified as soon as the user makes a selection on the Picker View Controller,
 presenting the "Done" button may be redundant. Conversely, If you are waiting for user to finish
 making selections and therefore want to be notified at the end of the selection process, presenting
 the "Back/Cancel" button may be redundant.
 */
public enum ToolbarButtonsDisplayOption: Int {
    /// displays both the Cancel and Done buttons that appears both sides of navigation bar (if present).
    /// User can click either button to dismiss the UI.
    /// Displaying both buttons may be redundant.
    case displayBothButtons
    
    /// displays the Cancel or Back button that appears on the leading side of the navigation bar (if present).
    /// User has to click this button to dismiss the UI.
    case displayCancelButtonOnly
    
    /// displays the Done button that appears on the trailing side of the navigation bar (if present).
    /// User has to click this button to dismiss the UI.
    case displayDoneButtonOnly
}
