//
//  TimeZoneOffset.swift
//
//
//  Created by eclypse on 12/28/23.
//

import Foundation

public struct TimeZoneOffset: Hashable, Codable, RawRepresentable {
    public typealias RawValue = String
    
    public let hourOffset: Int
    public let minuteOffset: Int
    public let rawValue: String
    public var timeZone: TimeZone? {
        return TimeZone(secondsFromGMT: hourOffset * 3600 + minuteOffset * 60)
    }
    
    /// rawValue is either UTC -10, UTC 0 or UTC +9:30
    public init(rawValue utcText: String) {
        self.rawValue = utcText
        let rawStringComponents = utcText.components(separatedBy: " ")
        if rawStringComponents.count == 2 {
            //we don't care about the first component as it always start with UTC
            //so only read the second component
            let rawOffSetInfo = rawStringComponents[1]
                        
            //second component could start with -, + or 0
            //get the first letter
            let firstLetter = String(rawOffSetInfo.first!)
            
            switch firstLetter {
            case "-":
                let hourAndMinuteComponents = rawOffSetInfo.components(separatedBy: ":")
                if hourAndMinuteComponents.count == 1 {
                    //there is no minute component in this utc
                    self.hourOffset = Int(hourAndMinuteComponents[0])! * -1
                    self.minuteOffset = 0
                } else {
                    self.hourOffset = Int(hourAndMinuteComponents[0])! * -1
                    self.minuteOffset = Int(hourAndMinuteComponents[1])! * -1
                }
            case "+":
                let hourAndMinuteComponents = rawOffSetInfo.components(separatedBy: ":")
                if hourAndMinuteComponents.count == 1 {
                    //there is no minute component in this utc
                    self.hourOffset = Int(hourAndMinuteComponents[0])!
                    self.minuteOffset = 0
                } else {
                    self.hourOffset = Int(hourAndMinuteComponents[0])!
                    self.minuteOffset = Int(hourAndMinuteComponents[1])!
                }
            default:
                self.hourOffset = 0
                self.minuteOffset = 0
            }
            
        } else {
            //assume this is UTC 0
            self.hourOffset = 0
            self.minuteOffset = 0
        }
    }
}
