//
//  ToolbarController.swift
//  Countries
//
//  Created by eclypse on 1/2/24.
//

import UIKit
import CountryKit

#if canImport(AppKit)
import AppKit
#endif

class ToolbarDelegate: NSObject {
}

#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
    static let search = NSToolbarItem.Identifier("com.company.countries.nstoolbaritem.search")
    static let clear = NSToolbarItem.Identifier("com.company.countries.nstoolbaritem.clear")
    
}
#endif

#if targetEnvironment(macCatalyst)
extension ToolbarDelegate: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarAllowedItemIdentifiers(toolbar)
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.search, .clear]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var toolbarItemToInsert: NSToolbarItem?
        
        switch itemIdentifier {
        case .search:
            let uiSearchBar = UISearchBar()
            uiSearchBar.backgroundImage = UIImage()
            uiSearchBar.placeholder = "Search"
            uiSearchBar.sizeToFit()
            uiSearchBar.delegate = self
            
            // !!! Warning !!!
            // using custom views is not supported when targeting macOS 12 or earlier
            // see https://developer.apple.com/documentation/appkit/nstoolbaritem/3375792-init
            let uibarButtonItem = UIBarButtonItem(customView: uiSearchBar)
            uibarButtonItem.width = 180
            let newItemToAdd = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: uibarButtonItem)
            
            newItemToAdd.isBordered = false
            toolbarItemToInsert = newItemToAdd
        case .clear:
            let newItemToAdd = NSToolbarItem(itemIdentifier: itemIdentifier)
            newItemToAdd.image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            newItemToAdd.action = #selector(ToolbarActionsResponder.clearSelections(_:))
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
        //toolbarItemToInsert?.isEnabled = false
        return toolbarItemToInsert
    }
}
#endif


extension ToolbarDelegate: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NotificationCenter.default.post(name: SearchBarEvent.toolbarSearchBarTextChanged.name, object: (searchBar.text ?? ""))
    }
}
