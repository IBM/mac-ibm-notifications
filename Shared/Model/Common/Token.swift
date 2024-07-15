//
//  Token.swift
//  Notification Agent
//
//  Created by Jan Valentik on 20/11/2021.
//  © Copyright IBM Corp. 2021, 2024
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
