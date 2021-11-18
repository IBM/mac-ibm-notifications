//
//  EFCLController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/26/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

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
    }

    // MARK: - Static variables

    static let shared = EFCLController()
    static let specialArguments = ["-NSDocumentRevisionsDebugMode",
                                   "--isRunningTest",
                                   "--v",
                                   "--help",
                                   "--version",
                                   "--terms",
                                   "--privacy",
                                   "--isRunningTestForCommandLine",
                                   "--config",
                                   "-reset",
                                   "sudo"]
    static let standaloneBooleanArguments = ["always_on_top", "silent", "miniaturizable", "force_light_mode"]
    // MARK: - Variables

    let context = Context.main
    let logger = NALogger.shared
    var isRunningTestForEFCL: Bool {
        return CommandLine.arguments.contains("--isRunningTestForCommandLine")
    }
}
