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
    
    // MARK: - Methods
    
    /// Check if the app is running testes for other workflows, debug or different workflow and if not start parsing the launch arguments.
    func parseArguments(_ arguments: [String] = CommandLine.arguments) {
        guard !arguments.contains("--isRunningTest") else { return }
        do {
            guard let base64EncodedData = arguments.last,
                  let data = Data(base64Encoded: base64EncodedData) else {
                Utils.applicationExit(withReason: .internalError)
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
                Utils.applicationExit(withReason: .internalError)
                return
            }
            logger.log("%{public}@", [efclError.localizedDescription])
            Utils.applicationExit(withReason: efclError.efclExitReason)
        }
    }
}
