//
//  EFCLController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/26/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Signals
import os.log

/// ExecutionFromCommandLineController handle the launch of the agent from command line.
final class EFCLController {

    // MARK: - Enums

    /// Exit reasons based on errors or user interactions.
    enum ExitReason {
        case untrackedSuccess
        case mainButtonClicked
        case secondaryButtonClicked
        case tertiaryButtonClicked
        case userDismissedNotification
        case userDismissedOnboarding
        case userFinishedOnboarding
        case invalidArgumentsSyntax
        case invalidArgumentFormat
        case internalError
        case cancelPressed
        case receivedSigInt
        case unableToLoadResources
        case timeout
        case exitWithInput(inputText: String)
    }

    // MARK: - Static variables

    static let shared = EFCLController()
    static let specialArguments = ["-NSDocumentRevisionsDebugMode",
                                   "--isRunningTest",
                                   "--v",
                                   "--help",
                                   "--version",
                                   "--isRunningTestForCommandLine",
                                   "--config",
                                   "-reset",
                                   "sudo"]
    static let standaloneBooleanArguments = ["always_on_top"]
    // MARK: - Variables

    let logger = Logger.shared
    var isRunningTestForEFCL: Bool {
        return CommandLine.arguments.contains("--isRunningTestForCommandLine")
    }
    var isRunningCommandLineWorkflow: Bool {
        return !(DeepLinkEngine.shared.agentTriggeredByDeepLink || APNSController.shared.agentTriggeredByAPNS) &&
            (isRunningTestForEFCL || ProcessInfo.processInfo.environment["TERM"] != nil)
    }

    // MARK: - Internal methods

    /// Exit the app with the related reason code.
    /// - Parameter reason: reason why the application should exit.
    /// - Returns: never.
    internal func applicationExit(withReason reason: ExitReason) {
        guard !isRunningTestForEFCL else { return }
        switch reason {
        case .untrackedSuccess:
            exit(200)
        case .mainButtonClicked, .userFinishedOnboarding:
            exit(0)
        case .secondaryButtonClicked:
            exit(2)
        case .tertiaryButtonClicked:
            exit(3)
        case .userDismissedNotification, .userDismissedOnboarding:
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
        case .exitWithInput(let inputValue):
            print(inputValue)
            exit(200)
        }
    }

    // MARK: - Methods

    /// Check if the app is running testes for other workflows, debug or different workflow and if not start parsing the launch arguments.
    func parseArguments(_ arguments: [String] = CommandLine.arguments) {
        guard isRunningCommandLineWorkflow else {
            guard DeepLinkEngine.shared.agentTriggeredByDeepLink || APNSController.shared.agentTriggeredByAPNS || CommandLine.arguments.contains("-NSDocumentRevisionsDebugMode") else {
                logger.log(.error, "Unrecognized notification agent launch attempt with arguments: %{public}@.", CommandLine.arguments)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [weak self] in
                    self?.applicationExit(withReason: .invalidArgumentsSyntax)
                })
                return
            }
            logger.log("Mac@IBM Notification Agent running normal workflow")
            return
        }
        logger.log("Mac@IBM Notification Agent running command line workflow")
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
                logger.log(.error, "No recognized error: %{public}@.", error.localizedDescription)
                applicationExit(withReason: .internalError)
                return
            }
            logger.log(.error, "%{public}@", efclError.localizedDescription)
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
            logger.log(.error, "Unrecognized subset of configuration parameters: %{public}@.", unrecognizedConfigurationsDict)
        }
        for configSet in recognizedConfigurationsDict {
            guard let defaultsKey = ConfigurableParameters.set[configSet.key] else {
                logger.log(.error, "%{public}@ key not set for unknown error.", configSet.key)
                continue
            }
            UserDefaults.standard.set(configSet.value, forKey: defaultsKey)
        }
        UserDefaults.standard.synchronize()
        logger.log("Notification Agent configuration completed.")
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
            logger.log(.error, "Unrecognized subset of configuration parameters: %{public}@.", unrecognizedConfigurations)
        }
        for config in recognizedConfigurations {
            guard let defaultsKey = ConfigurableParameters.set[config] else {
                logger.log("%{public}@ key not resetted for unknown error.", config)
                continue
            }
            UserDefaults.standard.set(nil, forKey: defaultsKey)
        }
        UserDefaults.standard.synchronize()
        logger.log("Notification Agent configuration reset completed.")
        applicationExit(withReason: .untrackedSuccess)
    }

    /// Check it the passed arguments includes some special argument and if so run the related workflow.
    /// - Parameter arguments: the app's launch arguments.
    private func checkSpecialArguments(_ arguments: [String]) {
        guard !arguments.contains("--help") else {
            HelpBuilder.printHelpPage()
            applicationExit(withReason: .untrackedSuccess)
            return
        }
        guard !arguments.contains("--version") else {
            HelpBuilder.printAppVersion()
            applicationExit(withReason: .untrackedSuccess)
            return
        }
        logger.isVerboseModeOn = arguments.contains("--v")
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
            return mappedKey
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
            checkedValues.insert("true", at: index)
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
