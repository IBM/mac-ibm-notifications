//
//  Notification-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/10/20.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension Notification.Name {
    static let showNotification = Notification.Name(rawValue: "showNotification")
    static let onboardingParentStatusDidChange = Notification.Name(rawValue: "onboardingParentStatusDidChange")
}
