//
//  UIFloat.swift
//  CountryKit
// 
//  Created by eclypse on 1/2/24.
//

import Foundation

#if targetEnvironment(macCatalyst)
import UIKit
public let supportsMacIdiom = !(UIDevice.current.userInterfaceIdiom == .pad)
#else
import Foundation
#endif

@inlinable public func UIFloat(_ value: CGFloat) -> CGFloat
{
    #if targetEnvironment(macCatalyst)
    return (value == 0.5) ? 0.5 : round(value * (supportsMacIdiom ? 0.77 : 1.0))
    #else
    return value
    #endif
}
