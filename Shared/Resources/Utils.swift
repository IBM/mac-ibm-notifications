//
//  Utils.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 9/24/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

struct Utils {
    enum InterfaceStyle: String {
        case dark = "Dark"
        case light = "Light"

        init() {
            let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
            self = InterfaceStyle(rawValue: type)!
        }
    }
    static var currentInterfaceStyle: InterfaceStyle {
        return InterfaceStyle()
    }
    static func runCommand(_ command: String, needAuthorize: Bool) -> String? {
        let scriptWithAuthorization = """
        do shell script "\(command)" with administrator privileges
        """
        
        let scriptWithoutAuthorization = """
        do shell script "\(command)"
        """
        
        let script = needAuthorize ? scriptWithAuthorization : scriptWithoutAuthorization
        let appleScript = NSAppleScript(source: script)
        
        var error: NSDictionary?
        let result = appleScript!.executeAndReturnError(&error)
        if let error = error {
            NALogger.shared.log("Apple script returned error: %{public}@", [error.description])
            return nil
        }
        
        return result.stringValue ?? ""
    }
    static func getDeviceUDID() -> String? {
        let command = String(#"ioreg -l | grep IOPlatformUUID | awk 'NR==1{print $4}' | sed 's/\"//g'"#)
        return Self.runCommand(command, needAuthorize: false)
    }
    static func write(_ dictionary: NSDictionary, to fileName: String) {
        let mainDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".ibmnotifier")
        if !FileManager.default.fileExists(atPath: mainDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: mainDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                NALogger.shared.log("Failed to create Mac@IBM Notifications directory in user domain with error: %{public}@", [error.localizedDescription])
                return
            }
        }
        let filePath = mainDirectory.appendingPathComponent("\(fileName)")
        guard dictionary.write(to: filePath, atomically: true) else {
            NALogger.shared.log("Failed to write onboarding choice result to temp file.")
            return
        }
    }
    static func delete(_ fileName: String) {
        let mainDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".ibmnotifier")
        if FileManager.default.fileExists(atPath: mainDirectory.path) {
            let filePath = mainDirectory.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: filePath.path) && FileManager.default.isDeletableFile(atPath: filePath.path) {
                do {
                    try FileManager.default.removeItem(atPath: filePath.path)
                } catch let error {
                    NALogger.shared.log("Failed to delete existing file at %{public}@ in user domain with error: %{public}@", [filePath.path, error.localizedDescription])
                    return
                }
            }
        }
    }
}
