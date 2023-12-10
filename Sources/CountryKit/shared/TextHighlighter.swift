//
//  TextHighlighter.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import UIKit

/// You use TextHighlighter to highlight search query within the target text
protocol TextHighlighter: AnyObject {
    /// returns an attributed text where each search component is highlighted if found within the text
    func highlightedText(sourceText: String, searchComponents: [String]) -> NSAttributedString
    
    /// returns an attributed text where each search component is highlighted if found within the text
    func highlightedText(sourceAttributedText: NSAttributedString, searchComponents: [String]) -> NSAttributedString
    
    /// returns an attributed string where the entire text is highlighted
    func highlightEntireText(sourceText: String, using color: UIColor?) -> NSAttributedString
}

class TextHighlighterImpl: TextHighlighter {
    func highlightedText(sourceAttributedText: NSAttributedString, searchComponents: [String]) -> NSAttributedString {
        return highlightedText(sourceText: sourceAttributedText.string, searchComponents: searchComponents)
    }
    
    func highlightEntireText(sourceText: String, using color: UIColor?) -> NSAttributedString {
        let attributedSourceText = NSMutableAttributedString(string: sourceText)
        let highlightColor = (color ?? UIColor(named: "color_primary_blue")?.withAlphaComponent(0.1)) ?? .systemBlue
        let textRange = NSRange(sourceText.startIndex ..< sourceText.endIndex, in: sourceText)
     
        attributedSourceText.addAttribute(NSAttributedString.Key.backgroundColor, value: highlightColor, range: textRange)
        
        return attributedSourceText
    }
        
    func highlightedText(sourceText: String, searchComponents: [String]) -> NSAttributedString {
        
        let attributedSourceText = NSMutableAttributedString(string: sourceText)
        let highlightColor = UIColor(named: "color_search_text_background") ?? UIColor.systemGreen
        
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
