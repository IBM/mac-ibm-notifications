//
//  APNSController.swift
//  NotificationAgent
//
//  Created by Simone Martorelli on 7/15/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import os.log

/// Handle the received remote notification.
final class APNSController {

    // MARK: - Static constants

    static let shared = APNSController()

    // MARK: Variables

    let logger = Logger.shared
    var agentTriggeredByAPNS: Bool = false

    // MARK: - Methods

    /// Handle the remote notification's user info and propagate a notification with a notification object built from it.
    /// - Parameter userInfo: the user info of the received notification.
    func receivedRemoteNotification(with userInfo: [String: Any]) {
        logger.log("APNSController received remote notification")
        do {
            let notificationObject = try NotificationObject(from: userInfo)
            logger.log("APNSController send received object to the UI")

            // Propagates the received notification
            NotificationCenter.default.post(name: .showNotification,
                                            object: self,
                                            userInfo: ["object": notificationObject])
        } catch {
            logger.log(.error,
                   "APNSController Error: %{public}@. No UI will be showed for the received push notification",
                   error.localizedDescription)
        }
    }
}
