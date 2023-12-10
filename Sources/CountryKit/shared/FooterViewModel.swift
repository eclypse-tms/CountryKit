//
//  FooterViewModel.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation

struct FooterViewModel: Hashable, Identifiable {
    /// simple identifier to separate different footers in the same view
    let id: String
    
    /// the footer text in the footer
    let callout: String
    
    /// you use clickableCallout to notify delegate that user clicked on the footer cell
    let clickableCallout: NSAttributedString?
    
    /// needed by interactable label which allows the user to see the highlighted text as they copy
    let textHighlighter: TextHighlighter?
    
    /// used by interactable label which allows the user to copy the contents of the footer text
    let shouldShowCopyButton: Bool
    
    /// if clickable callout has a URL link, you should set this field to true
    let externalLink: URL?
    
    /// make this property yes if you want additional padding around the footer text
    let shouldIncludeTopAndBottomPadding: Bool
    
    /// normally footercell has a width constraint of
    let ignoreWidthToTakeAllAvailableSpace: Bool
    
    init(callout: String,
         clickableCallout: NSAttributedString? = nil,
         id: String = "",
         textHighlighter: TextHighlighter? = nil,
         shouldShowCopyButton: Bool = false,
         externalLink: URL? = nil,
         shouldIncludeTopAndBottomPadding: Bool = true,
         ignoreWidthToTakeAllAvailableSpace: Bool = false) {
        self.id = id
        self.callout = callout
        self.textHighlighter = textHighlighter
        self.shouldShowCopyButton = shouldShowCopyButton
        self.clickableCallout = clickableCallout
        self.externalLink = externalLink
        self.shouldIncludeTopAndBottomPadding = shouldIncludeTopAndBottomPadding
        self.ignoreWidthToTakeAllAvailableSpace = ignoreWidthToTakeAllAvailableSpace
    }
    
    init(clickableCallout: NSAttributedString? = nil,
         id: String = "",
         textHighlighter: TextHighlighter? = nil,
         shouldShowCopyButton: Bool = false,
         externalLink: URL? = nil,
         shouldIncludeTopAndBottomPadding: Bool = true,
         ignoreWidthToTakeAllAvailableSpace: Bool = false) {
        self.id = id
        self.callout = ""
        self.textHighlighter = textHighlighter
        self.shouldShowCopyButton = shouldShowCopyButton
        self.clickableCallout = clickableCallout
        self.externalLink = externalLink
        self.shouldIncludeTopAndBottomPadding = shouldIncludeTopAndBottomPadding
        self.ignoreWidthToTakeAllAvailableSpace = ignoreWidthToTakeAllAvailableSpace
    }
    
    static func == (lhs: FooterViewModel, rhs: FooterViewModel) -> Bool {
        return lhs.callout == rhs.callout &&
            lhs.shouldShowCopyButton == rhs.shouldShowCopyButton &&
            lhs.clickableCallout == rhs.clickableCallout &&
            lhs.shouldIncludeTopAndBottomPadding == rhs.shouldIncludeTopAndBottomPadding &&
            lhs.externalLink == rhs.externalLink &&
            lhs.ignoreWidthToTakeAllAvailableSpace == rhs.ignoreWidthToTakeAllAvailableSpace
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(callout)
        hasher.combine(shouldShowCopyButton)
        hasher.combine(clickableCallout)
        hasher.combine(shouldIncludeTopAndBottomPadding)
        hasher.combine(externalLink)
        hasher.combine(ignoreWidthToTakeAllAvailableSpace)
    }
}
