//
//  Notification-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/10/20.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension Notification.Name {
    static let showNotification = Notification.Name(rawValue: "showNotification")
    static let onboardingParentStatusDidChange = Notification.Name(rawValue: "onboardingParentStatusDidChange")
}
