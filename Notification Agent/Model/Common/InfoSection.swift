//
//  InfoSection.swift
//  NotificationAgent
//
//  Created by Simone Martorelli on 8/18/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

struct InfoField: Codable {
    var label: String
    var description: String?
    var iconName: String?
}

struct InfoSection: Codable {
    var fields: [InfoField]
}
