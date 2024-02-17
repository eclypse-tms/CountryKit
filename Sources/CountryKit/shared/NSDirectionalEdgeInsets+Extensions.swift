//
//  NSDirectionalEdgeInsets+Extensions.swift
//
//
//  Created by Nessa Kucuk, Turker on 2/16/24.
//

import UIKit

public extension NSDirectionalEdgeInsets {
    /// initializes NSDirectionalEdgeInsets to the same padding value for all 4 directions.
    /// - Parameter padding: inset value to use for all 4 directions
    init (padding: CGFloat) {
        self = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
}
