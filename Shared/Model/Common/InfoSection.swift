//
//  InfoSection.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/18/20.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// A single info field
struct InfoField: Codable, Identifiable {
    var id: UUID
    var label: String
    var description: String?
    var iconName: String?
    
    init(label: String, description: String? = nil, iconName: String? = nil) {
        self.id = UUID()
        self.label = label
        self.description = description
        self.iconName = iconName
    }
    
    enum CodingKeys: CodingKey {
        case id
        case label
        case description
        case iconName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.label, forKey: .label)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.iconName, forKey: .iconName)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.id = UUID()
        self.iconName = try container.decodeIfPresent(String.self, forKey: .iconName)
    }
}

/// Thi object reprensent an info section with multiple info fields.
struct InfoSection: Codable {
    var fields: [InfoField]
}
