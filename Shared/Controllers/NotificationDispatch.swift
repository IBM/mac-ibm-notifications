//
//  NotificationDispatch.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/29/20.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa
import SystemConfiguration

/// Dispatch to the right controller the received notification object.
final class NotificationDispatch {

    // MARK: - Static constants

    static let shared = NotificationDispatch()
    
    // MARK: - Variables
    
    var taskManager = TaskManager()
    
    // MARK: - Methods

    /// Start observing for notifications triggered by other controllers.
    func startObservingForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receivedNotification),
                                               name: .showNotification,
                                               object: nil)
    }
}
