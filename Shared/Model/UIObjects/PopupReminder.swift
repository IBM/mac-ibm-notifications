//
//  PopupReminder.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/12/2021.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This class rapresent the pop-up reminder object.
/// This object describe the pop-up behaviour in case a periodic reminder has been set.
public final class PopupReminder: NSObject, Codable, NSSecureCoding {
    
    // MARK: - Variables
    
    /// The timeInterval after which the reminder should be triggered in seconds.
    var timeInterval: Double!
    /// Boolean value that define if the reminder should be repeated in loop.
    var repeatReminder: Bool = false
    /// Boolean value that define if the reminder should be silent.
    var silent: Bool = false
    
    // MARK: - Initializers
    
    init(with payload: String) throws {
        guard payload.contains("/timeinterval") else {
            throw NAError.dataFormat(type: .invalidReminderPayload)
        }
        var splittedStrings = payload.split(separator: "/")
        guard splittedStrings.count > 0 else {
            throw NAError.dataFormat(type: .invalidReminderPayload)
        }
        splittedStrings.reverse()
        for index in 0..<splittedStrings.count {
            guard let argument = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first?.lowercased() else { continue }
            let value = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).last?.trimmingCharacters(in: CharacterSet.whitespaces)
            switch argument {
            case "timeinterval":
                guard let value = value,
                      let number = NumberFormatter().number(from: value) else {
                          throw NAError.dataFormat(type: .invalidReminderPayload)
                      }
                self.timeInterval = Double(truncating: number)
            case "repeat":
                self.repeatReminder = true
            case "silent":
                self.silent = true
            default:
                break
            }
        }
    }
    
    // MARK: - Codable protocol conformity - START
    
    enum PRCodingKeys: String, CodingKey {
        case timeInterval
        case repeatReminder
        case silent
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PRCodingKeys.self)
        
        self.timeInterval = try container.decode(Double.self, forKey: .timeInterval)
        self.repeatReminder = try container.decode(Bool.self, forKey: .repeatReminder)
        self.silent = try container.decode(Bool.self, forKey: .silent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PRCodingKeys.self)
        try container.encode(self.timeInterval, forKey: .timeInterval)
        try container.encodeIfPresent(self.repeatReminder, forKey: .repeatReminder)
        try container.encodeIfPresent(self.silent, forKey: .silent)
    }
    
    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START
    
    public static var supportsSecureCoding: Bool = true
    
    public func encode(with coder: NSCoder) {
        let timeIntervalNumber = NSNumber(value: timeInterval)
        coder.encode(timeIntervalNumber, forKey: PRCodingKeys.timeInterval.rawValue)
        let repeatReminderNumber = NSNumber(booleanLiteral: repeatReminder)
        coder.encode(repeatReminderNumber, forKey: PRCodingKeys.repeatReminder.rawValue)
        let silentNumber = NSNumber(booleanLiteral: silent)
        coder.encode(silentNumber, forKey: PRCodingKeys.silent.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        self.timeInterval = coder.decodeObject(of: NSNumber.self, forKey: PRCodingKeys.timeInterval.rawValue)?.doubleValue
        self.repeatReminder = coder.decodeObject(of: NSNumber.self, forKey: PRCodingKeys.repeatReminder.rawValue)?.boolValue ?? false
        self.silent = coder.decodeObject(of: NSNumber.self, forKey: PRCodingKeys.silent.rawValue)?.boolValue ?? false
    }
    
    // MARK: - NSSecureCoding protocol conformity - END
}
