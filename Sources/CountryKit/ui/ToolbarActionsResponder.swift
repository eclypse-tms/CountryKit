//
//  ToolbarActionsResponder.swift
//
//
//  Created by eclypse on 1/3/24.
//

import Foundation

@objc
public protocol ToolbarActionsResponder: NSObjectProtocol {
    func clearSelections(_ sender: Any?)
    func share(_ sender: Any?)
    func search(_ sender: Any?)
}
