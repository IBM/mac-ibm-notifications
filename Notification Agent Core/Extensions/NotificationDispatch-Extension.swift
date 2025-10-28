//
//  NotificationDispatch-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 28/06/2021.
//  © Copyright IBM Corp. 2021, 2025
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
        case .popup, .systemalert:
            var isInteractive: Bool {
                var int = false
                object.notification.accessoryViews?.forEach({ accessoryView in
                    if accessoryView.type == .progressbar {
                        int = true
                    }
                })
                int = int || object.notification.warningButton != nil
                return int
            }
            taskManager.runAsyncTaskOnComponent(.popup, with: jsonData, isInteractive: isInteractive) { terminationStatus in
                exit(terminationStatus)
            }
        case .onboarding:
            var isInteractive: Bool {
                return object.notification.payload?.progressBarPayload != nil
            }
            taskManager.runAsyncTaskOnComponent(.onboarding, with: jsonData, isInteractive: isInteractive) { terminationStatus in
                exit(terminationStatus)
            }
        case .alert:
            taskManager.runAsyncTaskOnComponent(.alert, with: jsonData) { terminationStatus in
                exit(terminationStatus)
            }
        }
    }
}
