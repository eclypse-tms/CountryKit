//
//  CountryFilteringMethod.swift
//  CountryKit
//
//  Created by eclypse on 12/29/23.
//

import Foundation

/// Determines how a country list should be filtered given a search text
public protocol CountryFilteringMethod: AnyObject {
    /// indicates whether there is a valid search text and therefore a filter is applied to the full country list
    var isInSearchMode: Bool { get set }
    
    /// this highlighter takes a plain text and converts into NSAttributedString with matching search criteria highlighted
    var textHighlighter: TextHighlighter { get }
    
    /// the algorithm that performs the filtering criteria on the given country list
    func apply(searchQuery: String, fullCountryList: [Country], searchMethodology: SearchMethodology) -> [CountryViewModel]
}

public class CountryFilteringMethodImpl: CountryFilteringMethod {
    public let textHighlighter: TextHighlighter
    
    init(textHighlighter: TextHighlighter) {
        self.textHighlighter = textHighlighter
    }
    
    public var isInSearchMode = false
    
    public func apply(searchQuery: String, fullCountryList: [Country], searchMethodology: SearchMethodology) -> [CountryViewModel] {
        // Strip out all the leading and trailing spaces.
        let strippedString = searchQuery.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if strippedString.count == 0 {
            isInSearchMode = false
            return fullCountryList.map { CountryViewModel(country: $0) }
        } else {
            isInSearchMode = true
            let searchComponents = strippedString.components(separatedBy: " ") as [String]
            
            
            return fullCountryList.compactMap { eachCountry -> CountryViewModel? in
                
                var shouldIncludeThisCountry: Bool = false
                
                if searchMethodology == .orSearch {
                    //when doing an "OR" search - assume that we will not be including this country to begin with
                    //as soon as we get the first search component that is violating the search criteria, we bail out
                    //of the loop
                    shouldIncludeThisCountry = false
                    
                    for eachSearchComponent in searchComponents {
                        let rangeOfSearchComponent = eachCountry.localizedName.localizedStandardRange(of: eachSearchComponent)
                        if rangeOfSearchComponent != nil {
                            shouldIncludeThisCountry = true
                        }
                        if shouldIncludeThisCountry {
                            break
                        }
                    }
                } else {
                    //when doing an "AND" search - assume that we will be including this country to begin with
                    //as soon as we get the first search component that is violating the search criteria, we bail out
                    //of the loop
                    shouldIncludeThisCountry = true
                    for eachSearchComponent in searchComponents {
                        let rangeOfSearchComponent = eachCountry.localizedName.localizedStandardRange(of: eachSearchComponent)
                        if rangeOfSearchComponent == nil {
                            shouldIncludeThisCountry = false
                        }
                        if !shouldIncludeThisCountry {
                            break
                        }
                    }
                }
                
                if shouldIncludeThisCountry {
                    let textToHighlight = textHighlighter.highlightedText(sourceText: eachCountry.localizedName, searchComponents: searchComponents)
                    return CountryViewModel(country: eachCountry, highlightedText: textToHighlight)
                } else {
                    return nil
                }
            }
        }
    }
}
