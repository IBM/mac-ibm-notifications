//
//  NotificationDispatch.swift
//  NotificationAgent
//
//  Created by Simone Martorelli on 7/29/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa

/// Dispatch to the right controller the received notification object.
final class NotificationDispatch {

    // MARK: - Static constants

    static let shared = NotificationDispatch()

    // MARK: - Constants

    let userNotificationController = UserNotificationController.shared

    // MARK: - Methods

    /// Start observing for notifications triggered by other controllers.
    func startObservingForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receivedNotification),
                                               name: .showNotification,
                                               object: nil)
    }

    /// Handle the received notification and send the notification object to the correct controller.
    /// - Parameter notification: the received notification.
    @objc
    private func receivedNotification(_ notification: Notification) {
        guard let object = notification.userInfo?["object"] as? NotificationObject else { return }
        switch object.type {
        case .banner:
            userNotificationController.showBanner(object)
        case .popup:
            DispatchQueue.main.async {
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                guard let popUpViewController = storyboard.instantiateController(withIdentifier: PopUpViewController.identifier) as? PopUpViewController else { return }
                popUpViewController.notificationObject = object
                let window = NSWindow(contentViewController: popUpViewController)
                window.styleMask.remove(.resizable)
                window.styleMask.remove(.miniaturizable)
                window.styleMask.remove(.closable)
                window.center()
                window.makeKeyAndOrderFront(self)
                NSSound(named: .init("Funk"))?.play()
            }
        }
    }
}
