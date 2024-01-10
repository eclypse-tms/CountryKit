//
//  TimeZoneOffset.swift
//  CountryKit
// 
//  Created by eclypse on 12/28/23.
//

import Foundation

public struct TimeZoneOffset: Hashable, Codable, RawRepresentable, Comparable {
    public typealias RawValue = String
    
    /// the number of hours that is separated from UTC 0
    public let hourOffset: Int
    
    /// the number of minutes that is separated from its own primary UTC
    public let minuteOffset: Int
    
    /// whether this timezone is located on the east or west side of UTC. Eastern timezones have positive offset values.
    /// UTC 0 is a special case and is also considered to have positive offset
    public let offsetSign: OffsetSign
    
    /// rawValue reads as follows: UTC -10, UTC 0 or UTC +9:30
    public let rawValue: String
    
    /// indicates the number of seconds either positive or negative this timezone is separated from UTC 0.
    public var secondsFromUTC: Int {
        return hourOffset * 3600 + minuteOffset * 60
    }
    
    public var timeZone: TimeZone? {
        return TimeZone(secondsFromGMT: secondsFromUTC)
    }
    
    /// rawValue is either UTC -10, UTC 0 or UTC +9:30
    public init?(rawValue utcText: String) {
        guard !utcText.isEmpty else { return nil }
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
                    self.hourOffset = Int(hourAndMinuteComponents[0])!
                    self.minuteOffset = 0
                } else {
                    self.hourOffset = Int(hourAndMinuteComponents[0])!
                    self.minuteOffset = Int(hourAndMinuteComponents[1])!
                }
                self.offsetSign = .minus
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
                self.offsetSign = .plus
            default:
                self.hourOffset = 0
                self.minuteOffset = 0
                self.offsetSign = .zero
            }
        } else {
            //assume this is UTC 0
            self.hourOffset = 0
            self.minuteOffset = 0
            self.offsetSign = .zero
        }
    }
    
    /// timezones that are on the eastern hemisphere (positive values) are sorted first
    public static func < (lhs: TimeZoneOffset, rhs: TimeZoneOffset) -> Bool {
        return lhs.secondsFromUTC > rhs.secondsFromUTC
    }
}
