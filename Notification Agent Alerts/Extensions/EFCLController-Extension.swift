//
//  EFCLController-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/26/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension EFCLController {
    
    // MARK: - Internal methods
    
    /// Exit the app with the related reason code.
    /// - Parameter reason: reason why the application should exit.
    /// - Returns: never.
    internal func applicationExit(withReason reason: ExitReason) {
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
        }
    }
    
    // MARK: - Methods
    
    /// Check if the app is running testes for other workflows, debug or different workflow and if not start parsing the launch arguments.
    func parseArguments(_ arguments: [String] = CommandLine.arguments) {
        guard !UserNotificationController.shared.agentTriggeredByNotificationCenter else { return }
        do {
            guard let base64EncodedData = arguments.last,
                  let data = Data(base64Encoded: base64EncodedData) else {
                applicationExit(withReason: .internalError)
                return
            }
            let taskObject = try JSONDecoder().decode(TaskObject.self, from: data)
            context.sharedSettings = taskObject.settings
            NotificationCenter.default.post(name: .showNotification,
                                            object: self,
                                            userInfo: ["object": taskObject.notification])
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
}
