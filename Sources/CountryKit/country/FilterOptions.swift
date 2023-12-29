//
//  FilterOptions.swift
//
//
//  Created by eclypse on 12/29/23.
//

import Foundation

public struct FilterOptions: OptionSet, Hashable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// includes those countries, regions and territories that are not claimed by another sovereign state
    public static let sovereignState = FilterOptions(rawValue: 1 << 0)
    
    /// includes those countries, regions and territories that are a member of Commonwealth of Nations
    public static let commonwealthMember = FilterOptions(rawValue: 1 << 1)
    
    /// includes those regions and territories that are claimed by another sovereign state
    public static let dependentTerritory = FilterOptions(rawValue: 1 << 2)
    
    /// includes those regions and territories that have no permanent population (research and military settlement is not considered permanent population)
    public static let hasNoPermanentPopulation = FilterOptions(rawValue: 1 << 3)

    /// includes those regions and territories that are disputed by multiple countries and the ownership of that territory is under an international debate
    public static let disputedTerritories = FilterOptions(rawValue: 1 << 4)
    
    /// includes all ~250 countries, regions and territories
    public static let all: FilterOptions = [.sovereignState, .commonwealthMember, .dependentTerritory, .hasNoPermanentPopulation, .disputedTerritories]
}
