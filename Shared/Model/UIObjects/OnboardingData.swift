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
    var progressBarPayload: String?
    
    // MARK: - Codable protocol conformity - START

    enum ODCodingKeys: String, CodingKey {
        case pages
        case progressBarPayload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ODCodingKeys.self)
        if let interactiveOnboardingPages = try? container.decode([InteractiveOnboardingPage].self, forKey: .pages),
           let legacyOnboardingPages = try? container.decode([LegacyOnboardingPage].self, forKey: .pages) {
            if interactiveOnboardingPages.contains(where: { $0.accessoryViews != nil }) {
                self.pages = interactiveOnboardingPages
            } else {
                self.pages = legacyOnboardingPages
            }
        } else {
            throw NAError.dataFormat(type: .invalidJSONPayload)
        }
        if let payload = try? container.decodeIfPresent(String.self, forKey: .progressBarPayload) {
            self.progressBarPayload = payload
        }
    }

    public  func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ODCodingKeys.self)
        
        try container.encodeIfPresent(progressBarPayload, forKey: .progressBarPayload)
        guard let pages = self.pages as? [LegacyOnboardingPage] else {
            guard let pages = self.pages as? [InteractiveOnboardingPage] else {
                return
            }
            try container.encode(pages, forKey: .pages)
            return
        }
        try container.encode(pages, forKey: .pages)
    }

    // MARK: Codable protocol conformity - END
}

protocol OnboardingPage: Codable {
    // MARK: - Variables

    /// The title of the page.
    var title: String? { get }
    /// The subtitle of the page.
    var subtitle: String? { get }
    /// The body of the page.
    var body: String? { get }
    /// The info section showed with the click on the info button.
    var infoSection: InfoSection? { get }
    /// The path for a custom icon on top of the page
    var topIcon: String? { get }
    
    func isValidPage() -> Bool
}

/// This object describe a legacy onboarding page deprecated starting from v2.6.0.
final class LegacyOnboardingPage: OnboardingPage {

    // MARK: - Variables

    /// The title of the page.
    var title: String?
    /// The subtitle of the page.
    var subtitle: String?
    /// The body of the page.
    var body: String?
    /// The info section showed with the click on the info button.
    var infoSection: InfoSection?
    /// The path for a custom icon on top of the page
    var topIcon: String?
    /// The media type the desired media.
    var pageMedia: NAMedia?

    public func isValidPage() -> Bool {
        return title != nil || subtitle != nil || body != nil || pageMedia != nil
    }

    // MARK: - Codable protocol conformity - START

    enum NOCodingKeys: String, CodingKey {
        case title
        case subtitle
        case body
        case infoSection
        case topIcon
        case mediaType
        case mediaPayload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NOCodingKeys.self)
        
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.infoSection = try container.decodeIfPresent(InfoSection.self, forKey: .infoSection)
        self.topIcon = try container.decodeIfPresent(String.self, forKey: .topIcon)
        if let mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType),
           let mediaPayload = try container.decodeIfPresent(String.self, forKey: .mediaPayload) {
            self.pageMedia = NAMedia(type: mediaType, from: mediaPayload)
        }
    }

    public  func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NOCodingKeys.self)

        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.subtitle, forKey: .subtitle)
        try container.encodeIfPresent(self.body, forKey: .body)
        try container.encodeIfPresent(self.infoSection, forKey: .infoSection)
        try container.encodeIfPresent(self.topIcon, forKey: .topIcon)
        try container.encodeIfPresent(self.pageMedia?.mediaType.rawValue, forKey: .mediaType)
        try container.encodeIfPresent(self.pageMedia?.mediaPayload, forKey: .mediaPayload)
    }

    // MARK: Codable protocol conformity - END
}

/// This object describe an interactive onboarding page.
final class InteractiveOnboardingPage: OnboardingPage {

    // MARK: - Variables

    /// The title of the page.
    var title: String?
    /// The subtitle of the page.
    var subtitle: String?
    /// The body of the page.
    var body: String?
    /// The info section showed with the click on the info button.
    var infoSection: InfoSection?
    /// The path for a custom icon on top of the page
    var topIcon: String?
    /// Boolean value that define if the page could be browsed multiple time from the user to eventually modify acessorry view's choices.
    var singleChange: Bool?
    /// The list of accessory views for the page.
    var accessoryViews: [[NotificationAccessoryElement]]?

    public func isValidPage() -> Bool {
        return title != nil || subtitle != nil || body != nil || (accessoryViews != nil && !(accessoryViews?.isEmpty ?? true))
    }
}
