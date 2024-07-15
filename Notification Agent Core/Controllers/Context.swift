//
//  Context.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 31/03/2021.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// Application context
final class Context {
    
    static let main: Context = Context()

    // MARK: - Variables
    
    var sharedSettings: SharedSettings
    
    // MARK: - Initializers
    
    init() {
        self.sharedSettings = SharedSettings(isVerboseModeEnabled: false,
                                             environment: Environment.current)
    }
}
