//
//  Utils.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 9/24/20.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

struct Utils {
    
    // MARK: - Enums
    
    enum InterfaceStyle: String {
        case dark = "Dark"
        case light = "Light"

        init() {
            let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
            self = InterfaceStyle(rawValue: type)!
        }
    }
    
    /// Exit reasons based on errors or user interactions.
    enum ExitReason {
        case untrackedSuccess
        case mainButtonClicked
        case secondaryButtonClicked
        case tertiaryButtonClicked
        case userDismissedNotification
        case userDismissedOnboarding
        case userFinishedOnboarding
        case userDismissedPopup
        case invalidArgumentsSyntax
        case invalidArgumentFormat
        case internalError
        case cancelPressed
        case receivedSigInt
        case unableToLoadResources
        case timeout
    }
    
    // MARK: - Static Variables
    
    static var currentInterfaceStyle: InterfaceStyle {
        return InterfaceStyle()
    }
    static var UISoundEffectStatusEnable: Bool {
        let command = "defaults read -g com.apple.sound.uiaudio.enabled"
        if let result = Self.runCommand(command, needAuthorize: false) {
            let output = result.trimmingCharacters(in: .newlines)
            return Int(output) != 0
        } else {
            return true
        }
    }
    
    // MARK: - Static Methods
    
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
        let group = DispatchGroup()
        group.enter()
        let result = appleScript!.executeAndReturnError(&error)
        group.leave()
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
    
    /// Exit the app with the related reason code.
    /// - Parameter reason: reason why the application should exit.
    /// - Returns: never.
    static func applicationExit(withReason reason: ExitReason) {
        switch reason {
        case .untrackedSuccess:
            exit(200)
        case .mainButtonClicked, .userFinishedOnboarding:
            exit(0)
        case .secondaryButtonClicked:
            exit(2)
        case .tertiaryButtonClicked:
            exit(3)
        case .userDismissedNotification, .userDismissedOnboarding, .userDismissedPopup:
            exit(239)
        case .invalidArgumentsSyntax:
            exit(250)
        case .invalidArgumentFormat:
            exit(255)
        case .internalError, .cancelPressed:
            exit(1)
        case .receivedSigInt:
            exit(201)
        case .unableToLoadResources:
            exit(260)
        case .timeout:
            exit(4)
        }
    }
}
