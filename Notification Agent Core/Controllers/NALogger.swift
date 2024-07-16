//
//  Logger.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/27/20.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import os.log

/// A simple class based on Apple os.log that handle normal and verbose logs.
public final class NALogger {
    
    // MARK: - Static Variables
    
    static let shared = NALogger()
    
    // MARK: - Methods

    func log(_ type: OSLogType, _ message: StaticString, _ args: [String] = []) {
        Logger().log(level: type,
                     "\(String(format: message.description.replacingOccurrences(of: "{public}", with: ""), arguments: args), privacy: .public)")
        if Context.main.sharedSettings.isVerboseModeEnabled || type == .error {
            self.verbose(type, message, args)
        }
    }
    func log(_ message: StaticString, _ args: [String] = []) {
        Logger().log(level: .default,
                     "\(String(format: message.description.replacingOccurrences(of: "{public}", with: ""), arguments: args), privacy: .public)")
        if Context.main.sharedSettings.isVerboseModeEnabled {
            self.verbose(.default, message, args)
        }
    }
    func deprecationLog(since version: AppVersion, deprecatedArgument: String) {
        if version.isFinalDeprecatedVersion() {
            self.log(.error, "The following argument has been deprecated: %{public}@. Please update your workflow.", [deprecatedArgument])
        } else {
            self.log("The following argument has been deprecated and will not be supported anymore soon: %{public}@. Make sure to update your workflow as soon as possible.", [deprecatedArgument])
        }
    }
    
    // MARK: - Private Methods
    
    private func verbose(_ type: OSLogType, _ message: StaticString, _ args: [String] = []) {
        let message = type == .error ?
            message.description.replacingOccurrences(of: "{public}", with: "").red() :
            message.description.replacingOccurrences(of: "{public}", with: "").yellow()
        
        print(String(format: message, arguments: args))
    }
}
