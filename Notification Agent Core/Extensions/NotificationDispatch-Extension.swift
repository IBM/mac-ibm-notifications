//
//  NotificationDispatch-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 28/06/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension NotificationDispatch {
    /// Handle the received notification and send the notification object to the correct controller.
    /// - Parameter notification: the received notification.
    @objc
    func receivedNotification(_ notification: Notification) {
        guard let notificationObject = notification.userInfo?["object"] as? NotificationObject else {
            EFCLController.shared.applicationExit(withReason: .internalError)
            return
        }
        let object = TaskObject(notification: notificationObject, settings: Context.main.sharedSettings)
        guard let jsonData = try? JSONEncoder().encode(object) else {
            EFCLController.shared.applicationExit(withReason: .internalError)
            return
        }
        switch object.notification.type {
        case .banner:
            taskManager.runAsyncTaskOnComponent(.banner, with: jsonData) { terminationStatus in
                exit(terminationStatus)
            }
        case .popup:
            taskManager.runAsyncTaskOnComponent(.popup, with: jsonData) { terminationStatus in
                exit(terminationStatus)
            }
        case .onboarding:
            taskManager.runAsyncTaskOnComponent(.onboarding, with: jsonData) { terminationStatus in
                exit(terminationStatus)
            }
        case .alert:
            taskManager.runAsyncTaskOnComponent(.alert, with: jsonData) { terminationStatus in
                exit(terminationStatus)
            }
        }
    }
}
