//
//  SharedSettings.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/06/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This object represent the shared settings between the app components and the core service.
struct SharedSettings: Codable {
    var isVerboseModeEnabled: Bool
    var environment: Environment
}
