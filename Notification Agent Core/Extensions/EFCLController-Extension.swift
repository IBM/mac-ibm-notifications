//
//  EFCLController-Extension.swift
//  Notification Agent Banner
//
//  Created by Simone Martorelli on 28/06/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension EFCLController {
    
    // MARK: - Internal methods
    
    /// Exit the app with the related reason code.
    /// - Parameter reason: reason why the application should exit.
    /// - Returns: never.
    internal func applicationExit(withReason reason: Utils.ExitReason) {
        guard !isRunningTestForEFCL else { return }
        Utils.applicationExit(withReason: reason)
    }
    
    // MARK: - Methods
    
    /// Check if the app is running testes for other workflows, debug or different workflow and if not start parsing the launch arguments.
    func parseArguments(_ arguments: [String] = CommandLine.arguments) {
        guard !arguments.contains("--isRunningTest") else { return }
        guard !DeepLinkEngine.shared.agentTriggeredByDeepLink else { return }
        logger.log("Running command line workflow")
        do {
            checkSpecialArguments(arguments)
            try checkForConfigurationMode(arguments)
            let objectArguments = try clean(arguments)
            let keys = extractKeys(from: objectArguments)
            let values = extractValues(from: objectArguments)
            let dict = try buildDict(from: keys, and: values)
            let notificationObject = try createObject(from: dict)
            NotificationCenter.default.post(name: .showNotification,
                                            object: self,
                                            userInfo: ["object": notificationObject])
        } catch let error {
            guard let efclError = error as? NAError else {
                logger.log("No recognized error: %{public}@.", [error.localizedDescription])
                applicationExit(withReason: .internalError)
                return
            }
            logger.log("%{public}@", [efclError.localizedDescription])
            applicationExit(withReason: efclError.efclExitReason)
        }
    }
    
    // MARK: - Private methods
    
    /// Check if the passed arguments are configuration.
    /// - Parameter arguments: the app's launch arguments.
    /// - Throws: NAError.
    private func checkForConfigurationMode(_ arguments: [String]) throws {
        guard arguments.contains("--config") else { return }
        guard !arguments.contains("-reset") else {
            try resetConfigurations(arguments)
            return
        }
        let configArguments = try clean(arguments)
        let keys = extractKeys(from: configArguments)
        let values = extractValues(from: configArguments)
        let dict = try buildDict(from: keys, and: values)
        let unrecognizedConfigurationsDict = dict.filter({ !ConfigurableParameters.set.keys.contains($0.key) })
        let recognizedConfigurationsDict = dict.filter({ ConfigurableParameters.set.keys.contains($0.key) })
        if unrecognizedConfigurationsDict.count > 0 {
            logger.log("Unrecognized subset of configuration parameters: %{public}@.", [unrecognizedConfigurationsDict.description])
        }
        for configSet in recognizedConfigurationsDict {
            guard let defaultsKey = ConfigurableParameters.set[configSet.key] else {
                logger.log("%{public}@ key not set for unknown error.", [configSet.key])
                continue
            }
            UserDefaults.standard.set(configSet.value, forKey: defaultsKey)
        }
        UserDefaults.standard.synchronize()
        logger.log("Configuration completed.")
        applicationExit(withReason: .untrackedSuccess)
    }
    
    /// Reset the configuration values of configuration keys passed as arguments.
    /// - Parameter arguments: the app's launch arguments.
    /// - Throws: NAError.
    private func resetConfigurations( _ arguments: [String]) throws {
        let configArguments = try clean(arguments)
        let keys = extractKeys(from: configArguments)
        let unrecognizedConfigurations = keys.filter({ !ConfigurableParameters.set.keys.contains($0) })
        let recognizedConfigurations = keys.filter({ ConfigurableParameters.set.keys.contains($0) })
        if unrecognizedConfigurations.count > 0 {
            logger.log("Unrecognized subset of configuration parameters: %{public}@.", [unrecognizedConfigurations.description])
        }
        for config in recognizedConfigurations {
            guard let defaultsKey = ConfigurableParameters.set[config] else {
                logger.log("%{public}@ key not resetted for unknown error.", [config])
                continue
            }
            UserDefaults.standard.set(nil, forKey: defaultsKey)
        }
        UserDefaults.standard.synchronize()
        logger.log("Configuration reset completed.")
        applicationExit(withReason: .untrackedSuccess)
    }
    
    /// Check if the passed arguments includes some special argument and if so run the related workflow.
    /// - Parameter arguments: the app's launch arguments.
    private func checkSpecialArguments(_ arguments: [String]) {
        guard !arguments.contains("--help") else {
            HelpBuilder.printHelp(arguments)
            applicationExit(withReason: .untrackedSuccess)
            return
        }
        guard !arguments.contains("--version") else {
            HelpBuilder.printAppVersion()
            applicationExit(withReason: .untrackedSuccess)
            return
        }
        guard !arguments.contains("--privacy") else {
            HelpBuilder.printPrivacyPolicy()
            applicationExit(withReason: .untrackedSuccess)
            return
        }
        guard !arguments.contains("--terms") else {
            HelpBuilder.printTermsAndCondition()
            applicationExit(withReason: .untrackedSuccess)
            return
        }
        context.sharedSettings.isVerboseModeEnabled = arguments.contains("--v")
    }
    
    /// Clean the app's launch arguments from the special ones.
    /// - Parameter arguments: the app's launch arguments.
    /// - Throws: NAError.
    /// - Returns: the app's launch arguments without special argument.
    private func clean(_ arguments: [String]) throws -> [String] {
        var argumentsToClean = arguments
        argumentsToClean.removeFirst()
        argumentsToClean.removeAll(where: { Self.specialArguments.contains($0) })
        guard !argumentsToClean.isEmpty else {
            HelpBuilder.printNoArgumentsPage()
            throw NAError.efclController(type: .invalidArgumentsSyntax)
        }
        return argumentsToClean
    }
    
    /// Extract the "key" arguments (-argument).
    /// - Parameter arguments: the app's cleaned launch arguments.
    /// - Returns: the array of key argument.
    private func extractKeys(from arguments: [String]) -> [String] {
        var keys = arguments.filter({ $0.first == "-" })
        keys = keys.map({ key in
            var mappedKey: String = key
            mappedKey.removeAll(where: { $0 == "-" })
            return mappedKey.lowercased()
        })
        return keys
    }
    
    /// Extract the "value" arguments (argument).
    /// - Parameter arguments: the app's cleaned launch arguments.
    /// - Returns: the array of value argument.
    private func extractValues(from arguments: [String]) -> [String] {
        return arguments.filter({ $0.first != "-" })
    }
    
    private func buildDict(from keys: [String], and values: [String]) throws -> [String: Any] {
        var checkedValues = values
        guard !keys.isEmpty && !values.isEmpty else {
            HelpBuilder.printNoArgumentsPage()
            throw NAError.efclController(type: .invalidArgumentsSyntax)
        }
        for arg in Self.standaloneBooleanArguments {
            guard let index = keys.firstIndex(where: { $0 == arg }) else { continue }
            if index > checkedValues.count {
                checkedValues.append("true")
            } else {
                checkedValues.insert("true", at: index)
            }
        }
        guard keys.count == checkedValues.count else {
            throw NAError.efclController(type: .invalidArgumentsFormat)
        }
        var dict: [String: Any] = [:]
        for index in keys.indices {
            dict[keys[index]] = checkedValues[index]
        }
        return dict
    }
    
    /// Try to create a NotificationObject from the passed dictionary.
    /// - Parameter dict: the passed dictionary.
    /// - Throws: NAError.
    /// - Returns: a NotificationObject.
    private func createObject(from dict: [String: Any]) throws -> NotificationObject {
        do {
            let notificationObject = try NotificationObject(from: dict)
            logger.log("Notification object successfully created from arguments list.")
            return notificationObject
        } catch let error {
            throw NAError.efclController(type: .errorBuildingNotificationObject(description: error.localizedDescription))
        }
    }
}
