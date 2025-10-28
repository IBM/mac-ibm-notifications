//
//  Environment.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 28/04/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

struct Constants {
    static internal var environmentUDKey: String = "environment"
    static internal var loginItemEnabledUDKey = "loginItemEnabled"
    static internal let storeFileName = "IBM_Notifier_Onboarding.plist"
}

struct AppVersion: Comparable, Equatable {
    let major: Int
    let release: Int
    let fix: Int
    
    var current: AppVersion? {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return nil }
        let components = appVersion.split(separator: ".")
        guard components.count == 3,
              let major = Int(components[0]),
              let release = Int(components[1]),
              let fix = Int(components[2]) else { return nil }
        return AppVersion(major: major, release: release, fix: fix)
    }
    
    func isFinalDeprecatedVersion() -> Bool {
        guard let currentVersion = self.current else {
            return false
        }
        return currentVersion >= self
    }
    
    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major < rhs.major {
            return true
        } else if lhs.major == rhs.major {
            return lhs.release < rhs.release
        } else {
            return false
        }
    }
}

//  swiftlint:disable identifier_name

enum Environment: String, Codable {
    case eng
    case qa
    case prod
    
    static var current: Environment {
        if let environmentRawValue = UserDefaults.standard.string(forKey: Constants.environmentUDKey),
           let environment = Environment(rawValue: environmentRawValue.lowercased()) {
            return environment
        } else {
            return prod
        }
    }
}

//  swiftlint:enable identifier_name
