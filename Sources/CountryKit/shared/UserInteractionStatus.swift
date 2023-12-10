//
//  UserInteractionStatus.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation

/// You use UserInteractionStatus to differentiate the reason why a user can or cannot interact with a particular part of the app
enum UserInteractionStatus: Int, CaseIterable {
    
    /// user interaction is enabled. typically it means, user can change an object as a result of this interaction
    case interactionEnabled
    
    /// only a user with correct permissions can interact with this object
    case insufficientPermissions
    
    /// some screens are shown to the user only as a display only / reference purposes. It is not expected
    /// for the user to interact with the elements
    case displayOnlyMode
    
    /// short hand for true or false statements
    var isUserInteractionEnabled: Bool {
        return self == .interactionEnabled
    }
}
