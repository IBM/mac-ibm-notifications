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
        DispatchQueue.main.async {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let popUpViewController = storyboard.instantiateController(withIdentifier: PopUpViewController.identifier) as? PopUpViewController else { return }
            popUpViewController.notificationObject = object
            let window = NSWindow(contentViewController: popUpViewController)
            window.styleMask.remove(.resizable)
            if !(object.isMiniaturizable ?? false) {
                window.styleMask.remove(.miniaturizable)
            }
            window.styleMask.remove(.closable)
            window.makeKeyAndOrderFront(self)
            guard object.silent == false else { return }
            NSSound(named: .init("Funk"))?.play()
        }
    }
}
