//
//  SearchMethod.swift
//
//
//  Created by Turker Nessa Kucuk on 12/29/23.
//

import Foundation

/*
open class SearchMethod {
    open var isInSearchMode = false
    /// determines how the search should happen
    /// override it to customize the search behavior and make sure to call reloadDataRelay.send(true) at the end.
    open func apply(fullCountryList: [Country], searchQuery: String, searchMethodology: SearchMethodology) -> [CountryViewModel] {
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
                        if eachCountry.localizedName.range(of: eachSearchComponent, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
                            shouldIncludeThisCountry = true
                        }
                    }
                } else {
                    //when doing an "AND" search - assume that we will be including this country to begin with
                    //as soon as we get the first search component that is violating the search criteria, we bail out
                    //of the loop
                    shouldIncludeThisCountry = true
                    for eachSearchComponent in searchComponents {
                        if eachCountry.localizedName.range(of: eachSearchComponent, options: [.caseInsensitive, .diacriticInsensitive]) == nil {
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
        reloadDataRelay.send(true)
    }
}
*/
