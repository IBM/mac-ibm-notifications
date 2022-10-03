//
//  AppDelegate.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 18/06/2021.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let userNotificationController = UserNotificationController.shared
    let notificationDispatch = NotificationDispatch.shared
    let efclController = EFCLController.shared
    let context = Context.main
    let logger = NALogger.shared
    var isConfigured: Bool = false

    private func configureApp(_ completion: @escaping () -> Void = {}) {
        guard !isConfigured else {
            completion()
            return
        }
        isConfigured = true
        notificationDispatch.startObservingForNotifications()
        guard !UserNotificationController.shared.agentTriggeredByNotificationCenter else {
            completion()
            return
        }
        efclController.parseArguments()
        completion()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureApp()
    }
}
