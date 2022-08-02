//
//  NotificationButton.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/9/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This struct describe a button that can be added to the view showed to the user.
public class NotificationButton: NSObject, Codable, NSSecureCoding {

    // MARK: - Enums

    /// The type of the call to action could be:
    /// - none: close the popup/banner without trigger any action.
    /// - link: open a web link.
    /// - echo: echo the payload.
    /// - infopopup: show a little popup with text. Applicable only to "help" type buttons.
    enum CTAType: String {
        case none
        case link
        case infopopup
        case exitlink
    }

    // MARK: - Variables

    /// The label of the button. Available only for "standard" type buttons.
    var label: String
    /// The type of the call to action.
    var callToActionType: CTAType
    /// The payload of the cta.
    var callToActionPayload: String

    // MARK: - Initializers

    init(with label: String, callToActionType: CTAType, callToActionPayload: String) {
        self.label = label
        self.callToActionType = callToActionType
        self.callToActionPayload = callToActionPayload
    }

    // MARK: - Codable protocol conformity - START

    enum NBCodingKeys: String, CodingKey {
        case label
        case callToActionType
        case callToActionPayload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NBCodingKeys.self)

        self.label = try container.decode(String.self, forKey: .label)
        let typeRawValue = try container.decode(String.self, forKey: .callToActionType)
        self.callToActionType = CTAType(rawValue: typeRawValue) ?? .none
        self.callToActionPayload = try container.decode(String.self, forKey: .callToActionPayload)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NBCodingKeys.self)

        try container.encode(self.label, forKey: .label)
        try container.encode(self.callToActionType.rawValue, forKey: .callToActionType)
        try container.encode(self.callToActionPayload, forKey: .callToActionPayload)
    }

    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START

    public static var supportsSecureCoding: Bool = true

    public func encode(with coder: NSCoder) {
        coder.encode(self.label, forKey: NBCodingKeys.label.rawValue)
        coder.encode(self.callToActionType.rawValue, forKey: NBCodingKeys.callToActionType.rawValue)
        coder.encode(self.callToActionPayload, forKey: NBCodingKeys.callToActionPayload.rawValue)
    }

    public required init?(coder: NSCoder) {
        self.label = coder.decodeObject(of: NSString.self, forKey: NBCodingKeys.label.rawValue) as String? ?? ""
        self.callToActionType = CTAType(rawValue: coder.decodeObject(of: NSString.self, forKey: NBCodingKeys.callToActionType.rawValue) as String? ?? "none") ?? .none
        self.callToActionPayload = coder.decodeObject(of: NSString.self, forKey: NBCodingKeys.callToActionPayload.rawValue) as String? ?? ""
    }

    // MARK: - NSSecureCoding protocol conformity - END
}
