//
//  TextHighlighter.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import UIKit

/// You use TextHighlighter to highlight search query within a target text
public protocol TextHighlighter: AnyObject {
    /// returns an attributed text where each search component is highlighted if found within the text
    func highlightedText(sourceText: String, searchComponents: [String]) -> NSAttributedString
}

open class TextHighlighterImpl: TextHighlighter {
    public func highlightedText(sourceText: String, searchComponents: [String]) -> NSAttributedString {
        
        let attributedSourceText = NSMutableAttributedString(string: sourceText)
        let highlightColor = UIColor(named: "color_search_text_background", in: CountryKit.assetBundle, compatibleWith: nil) ?? UIColor.systemYellow
        
        for eachTextToSearch in searchComponents {
            //Finds and returns the range of the first occurrence of a given string within the string by performing a case and diacritic insensitive, locale-aware search.
            if let rangeCandidate = sourceText.localizedStandardRange(of: eachTextToSearch) {
                let rangeOfTextToHighlight = NSRange(rangeCandidate, in: sourceText)
                attributedSourceText.addAttribute(NSAttributedString.Key.backgroundColor, value: highlightColor, range: rangeOfTextToHighlight)
                attributedSourceText.addAttribute(NSAttributedString.Key.strokeWidth, value: NSNumber(floatLiteral: -3.0), range: rangeOfTextToHighlight)
            }
        }
        return attributedSourceText
    }
}
