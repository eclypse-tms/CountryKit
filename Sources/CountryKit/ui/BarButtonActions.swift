//
//  BarButtonActions.swift
//  
//
//  Created by Turker Nessa on 12/12/23.
//

import UIKit

/// this class stores the actions that are provided with CountrySelectionConfiguration
/// we need to store them so that we can execute those actions as well as our own callbacks
/// when the user clicks "Back" or "Done" in the UI
class AdditionalBarButtonActions {
    init() {}
    
    //additional actions provided
    var providedActionForLeftBarButton: UIAction?
    var providedTargetForLeftBarButton: AnyObject?
    var providedSelectorForLeftBarButton: Selector?
    
    var providedActionForRightBarButton: UIAction?
    var providedTargetForRightBarButton: AnyObject?
    var providedSelectorForRightBarButton: Selector?
}
