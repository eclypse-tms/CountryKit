//
//  CountryPoolOptions.swift
//
//
//  Created by eclypse on 12/29/23.
//

import Foundation

/// Controls which countries, regions or territories to display in the PickerUI.
///
/// By default, PickerUI includes all territories that have an alpha 2 code assigned to it.
public struct CountryPoolOptions: OptionSet, Hashable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// includes those countries, regions and territories that are not claimed by another sovereign state, are not a disputed territory and have a permanent population
    public static let sovereignStates = CountryPoolOptions(rawValue: 1 << 0)
    
    /// includes those countries, regions and territories that are a member of Commonwealth of Nations
    public static let commonwealthMembers = CountryPoolOptions(rawValue: 1 << 1)
    
    /// includes those regions and territories that are claimed by another sovereign state
    public static let dependentTerritories = CountryPoolOptions(rawValue: 1 << 2)
    
    /// includes those regions and territories that have no permanent population (research and military settlement is not considered permanent population)
    public static let noPermanentPopulation = CountryPoolOptions(rawValue: 1 << 3)

    /// includes those regions and territories that are disputed by multiple countries and the ownership of that territory is under an international debate
    public static let disputedTerritories = CountryPoolOptions(rawValue: 1 << 4)
    
    /// includes all ~250 countries, regions and territories
    public static let all: CountryPoolOptions = [.sovereignStates, .commonwealthMembers, .dependentTerritories, .noPermanentPopulation, .disputedTerritories]
}
