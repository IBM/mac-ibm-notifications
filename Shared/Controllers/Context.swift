//
//  Context.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 31/03/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// Application context
final class Context {
    
    static let main: Context = Context()

    // MARK: - Variables
    
    var sharedSettings: SharedSettings?
    
    // MARK: - Initializers
    
    init() {
        
    }
}
