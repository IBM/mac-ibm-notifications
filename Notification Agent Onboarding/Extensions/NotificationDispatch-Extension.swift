//
//  NotificationDispatch-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 5/27/21.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa

extension NotificationDispatch {
    /// Handle the received notification and send the notification object to the correct controller.
    /// - Parameter notification: the received notification.
    @objc
    func receivedNotification(_ notification: Notification) {
        guard let object = notification.userInfo?["object"] as? NotificationObject else { return }
        guard let onboardingData = object.payload else { return }
        let onboardingViewController = OnboardingViewController(with: onboardingData, alwaysOnTop: object.alwaysOnTop ?? false)
        let window = NSWindow(contentViewController: onboardingViewController)
        window.styleMask.remove(.resizable)
        if object.payload?.progressBarPayload != nil {
            window.styleMask.remove(.closable)
            window.styleMask.remove(.miniaturizable)
        } else if object.hideTitleBarButtons ?? false {
            window.styleMask.remove(.closable)
            window.styleMask.remove(.miniaturizable)
        }
        if object.forceLightMode ?? false {
            window.appearance = NSAppearance(named: .aqua)
        }
        window.title = ""
        window.titlebarAppearsTransparent = true
        window.center()
        window.delegate = onboardingViewController
        window.makeKeyAndOrderFront(self)
    }
}
