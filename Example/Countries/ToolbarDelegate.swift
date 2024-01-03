//
//  ToolbarController.swift
//  Countries
//
//  Created by Nessa Kucuk, Turker on 1/2/24.
//

import UIKit
import CountryKit

#if canImport(AppKit)
import AppKit
#endif

class ToolbarDelegate: NSObject {
}

extension NSToolbarItem.Identifier {
    static let search = NSToolbarItem.Identifier("com.company.countries.nstoolbaritem.search")
    static let share = NSToolbarItem.Identifier("com.company.countries.nstoolbaritem.search")
    static let clear = NSToolbarItem.Identifier("com.company.countries.nstoolbaritem.search")
    
}

#if targetEnvironment(macCatalyst)
extension ToolbarDelegate: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarAllowedItemIdentifiers(toolbar)
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .share, .clear, .search]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var toolbarItemToInsert: NSToolbarItem?
        
        switch itemIdentifier {
        case .search:
            let newItemToAdd = NSToolbarItem(itemIdentifier: itemIdentifier)
            let uiSearchBar = UISearchBar()
            uiSearchBar.backgroundImage = UIImage() //an empty image removes the default background color
            //uiSearchBar.placeholder = "Search"
            uiSearchBar.delegate = self //or whichever object most appropriate
              
            // using custom views is not supported when targeting macOS 12 or earlier
            // see https://developer.apple.com/documentation/appkit/nstoolbaritem/3375792-init
            let uibarButtonItem = UIBarButtonItem(customView: uiSearchBar)
            toolbarItemToInsert = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: uibarButtonItem)
            
            newItemToAdd.action = #selector(ToolbarActionsResponder.search(_:))
            newItemToAdd.isBordered = true
            toolbarItemToInsert = newItemToAdd
        case .share:
            let newItemToAdd = NSToolbarItem(itemIdentifier: itemIdentifier)
            newItemToAdd.image = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(UIColor(named: "color_bar_button_mac")!)
            newItemToAdd.action = #selector(ToolbarActionsResponder.share(_:))
            newItemToAdd.isBordered = true
            toolbarItemToInsert = newItemToAdd
        case .clear:
            let newItemToAdd = NSToolbarItem(itemIdentifier: itemIdentifier)
            newItemToAdd.image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(UIColor(named: "color_bar_button_mac")!)
            newItemToAdd.action = #selector(ToolbarActionsResponder.clear(_:))
            newItemToAdd.isBordered = true
            toolbarItemToInsert = newItemToAdd
        case .flexibleSpace:
            toolbarItemToInsert = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.flexibleSpace)
        default:
            //nothing to do
            break
        }
        

        toolbarItemToInsert?.target = nil
        toolbarItemToInsert?.autovalidates = false
        toolbarItemToInsert?.isEnabled = false
        return toolbarItemToInsert
    }
}
#endif


extension ToolbarDelegate: UISearchBarDelegate {
    
}
