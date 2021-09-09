//
//  InfoSection.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/18/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// A single info field
struct InfoField: Codable {
    var label: String
    var description: String?
    var iconName: String?
}

/// Thi object reprensent an info section with multiple info fields.
struct InfoSection: Codable {
    var fields: [InfoField]
}
