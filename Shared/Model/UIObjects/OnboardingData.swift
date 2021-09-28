//
//  OnboardingData.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 21/01/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa
import AVFoundation

/// This object describe the data defined for the onboarding.
public final class OnboardingData: Codable {
    /// An array of pages.
    var pages: [OnboardingPage]
}

/// This object describe an onboarding page.
public final class OnboardingPage: Codable {

    // MARK: - Variables

    /// The title of the page.
    var title: String?
    /// The subtitle of the page.
    var subtitle: String?
    /// The body of the page.
    var body: String?
    /// The media type the desired media.
    var pageMedia: NAMedia?
    /// The info section showed with the click on the info button.
    var infoSection: InfoSection?
    /// The path for a custom icon on top of the page
    var topIcon: String?

    public func isValidPage() -> Bool {
        return title != nil || subtitle != nil || body != nil || pageMedia != nil
    }

    // MARK: - Codable protocol conformity - START

    enum NOCodingKeys: String, CodingKey {
        case title
        case subtitle
        case body
        case mediaType
        case mediaPayload
        case infoSection
        case topIcon
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NOCodingKeys.self)

        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        if let mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType),
           let mediaPayload = try container.decodeIfPresent(String.self, forKey: .mediaPayload) {
            self.pageMedia = NAMedia(type: mediaType, from: mediaPayload)
        }
        self.infoSection = try container.decodeIfPresent(InfoSection.self, forKey: .infoSection)
        self.topIcon = try container.decodeIfPresent(String.self, forKey: .topIcon)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NOCodingKeys.self)

        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.subtitle, forKey: .subtitle)
        try container.encodeIfPresent(self.body, forKey: .body)
        try container.encodeIfPresent(self.pageMedia?.mediaType.rawValue, forKey: .mediaType)
        try container.encodeIfPresent(self.pageMedia?.mediaPayload, forKey: .mediaPayload)
        try container.encodeIfPresent(self.infoSection, forKey: .infoSection)
        try container.encodeIfPresent(self.topIcon, forKey: .topIcon)
    }

    // MARK: Codable protocol conformity - END
}
