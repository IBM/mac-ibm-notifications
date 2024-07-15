//
//  TaskObject.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/06/2021.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This object represent a task sent from the core service to one of the app components.
struct TaskObject: Codable {
    var notification: NotificationObject
    var settings: SharedSettings
}
