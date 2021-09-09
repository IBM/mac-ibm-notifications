//
//  Token.swift
//  Notification Agent
//
//  Created by Jan Valentik on 20/11/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This object represent a received auth Token.
internal struct Token: Codable {
    var value: String
    var expiration: Date?
    var isExpired: Bool {
        guard let exp = expiration else {
            return true
        }
        return exp < Date()
    }
}
