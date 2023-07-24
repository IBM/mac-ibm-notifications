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
    var pages: [InteractiveOnboardingPage]
    var progressBarPayload: String?
    
    // MARK: - Codable protocol conformity - START

    enum ODCodingKeys: String, CodingKey {
        case pages
        case progressBarPayload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ODCodingKeys.self)
        if let interactiveOnboardingPages = try? container.decode([InteractiveOnboardingPage].self, forKey: .pages) {
            self.pages = interactiveOnboardingPages
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
        try container.encode(pages, forKey: .pages)
    }

    // MARK: Codable protocol conformity - END
}

/// This object describe an interactive onboarding page.
final class InteractiveOnboardingPage: Codable {

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
    /// A tertiary button available on the page.
    var tertiaryButton: NotificationButton?
    /// Custom label for the primary button.
    var primaryButtonLabel: String?
    /// Custom label for the secondary button.
    var secondaryButtonLabel: String?

    public func isValidPage() -> Bool {
        return title != nil || subtitle != nil || body != nil || (accessoryViews != nil && !(accessoryViews?.isEmpty ?? true))
    }
}
