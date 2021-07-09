//
//  NotificationObject.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 7/9/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable function_body_length

import Foundation

/// The object used to describe the received notification to be showed to the user.
public final class NotificationObject: NSObject, Codable, NSSecureCoding {

    // MARK: - Enums

    /// The allowed type of notification that can be showed.
    enum UIType: String {
        case popup // Popup window.
        case banner // Temporary user notification banner.
        case onboarding // Onboarding window.
    }

    // MARK: - Variables
    
    /// The identifier of the notification object.
    /// Used to better handle the answer of the user.
    var identifier: UUID
    /// The type of the notification.
    var type: UIType
    /// The bar title for the "popup" UI type. Not used for "notification" UI type.
    var barTitle: String?
    /// The title of the notification.
    var title: String?
    /// The subtitle of the notification.
    var subtitle: String?
    /// Custom icon path defined for this notification object (Available only for popup UIType).
    var iconPath: String?
    /// The accessory view that needs to be added to the notification. This will be showed only for "popup" notification type.
    var accessoryView: NotificationAccessoryElement?
    /// The main button of the notification that needs to be showed to the user.
    /// It represent also the default action for the timeout.
    var mainButton: NotificationButton
    /// The secondary button of the notification that needs to be showed to the user.
    var secondaryButton: NotificationButton?
    /// The tertiary button of the notification that needs to be showed to the user.
    var tertiaryButton: NotificationButton?
    /// The help button of the notification that needs to be showed to the user.
    /// For this button the label value will be ignored since the button is represented by a question mark icon.
    var helpButton: NotificationButton?
    /// The timeout for the notification. After this amount of seconds past a default action is triggered.
    var timeout: String?
    /// A boolean value that set if the pop-up window if always on top of the window hierarchy.
    var alwaysOnTop: Bool?
    /// A boolean value that set if the pop-up must not trigger any sound when appear.
    var silent: Bool?
    /// The payload data needed for the "onboarding" UI type.
    var payload: OnboardingData?

    // MARK: - Initializers
    
    /// Create a NotificationObject starting from a dictionary of elements.
    /// - Parameter dictionary: the dictionary.
    /// - Throws: throws an error if the passed dictionary doesn't
    /// have all the info needed to build a NotificationObject.
    init(from dict: [String: Any]) throws {
        self.identifier = UUID()
        guard let typeRawValue = dict["type"] as? String,
            let type = UIType(rawValue: typeRawValue) else {
                throw NAError.dataFormat(type: .noTypeDefined)
        }
        self.type = type
        self.barTitle = dict["bar_title"] as? String
        self.title = dict["title"] as? String
        self.subtitle = dict["subtitle"] as? String
        self.iconPath = dict["icon_path"] as? String
        if let onboardingRawData = dict["payload"] as? String {
            self.payload = try Self.loadOnboardingPayload(onboardingRawData)
        }

        if let accessoryviewTyperawValue = dict["accessory_view_type"] as? String,
            let accessoryViewType = NotificationAccessoryElement.ViewType.init(rawValue: accessoryviewTyperawValue),
            let accessoryViewPayload = dict["accessory_view_payload"] as? String {
            self.accessoryView = NotificationAccessoryElement(with: accessoryViewType, payload: accessoryViewPayload)
        }

        // Main button is mandatory so if not defined from who trigger the notification will be used a default one that show a default label and trigger no actions.
        let mainButtonLabel = dict["main_button_label"] as? String ?? ConfigurableParameters.defaultMainButtonLabel
        let mainButtonCTAType = NotificationButton.CTAType(rawValue: dict["main_button_cta_type"] as? String ?? "none") ?? .none
        let mainButtonCTAPayload = (dict["main_button_cta_payload"] as? String) ?? ""
        self.mainButton = NotificationButton(with: mainButtonLabel, callToActionType: mainButtonCTAType, callToActionPayload: mainButtonCTAPayload)

        // Secondary button is not mandatory. If found the label but not the cta type and payload it will be set to "none".
        if let secondaryButtonLabel = dict["secondary_button_label"] as? String,
            let secondaryButtonCTAType = NotificationButton.CTAType(rawValue: dict["secondary_button_cta_type"] as? String ?? "none") {
                self.secondaryButton = NotificationButton(with: secondaryButtonLabel, callToActionType: secondaryButtonCTAType, callToActionPayload: dict["secondary_button_cta_payload"] as? String ?? "")
        }

        if let tertiaryButtonLabel = dict["tertiary_button_label"] as? String,
            let tertiaryButtonCTATypeRawValue = dict["tertiary_button_cta_type"] as? String,
            let tertiaryButtonCTAType = NotificationButton.CTAType(rawValue: tertiaryButtonCTATypeRawValue),
            let tertiaryButtonCTAPayload = dict["tertiary_button_cta_payload"] as? String {
            self.tertiaryButton = NotificationButton(with: tertiaryButtonLabel, callToActionType: tertiaryButtonCTAType, callToActionPayload: tertiaryButtonCTAPayload)
        }

        if let helpButtonTypeRawValue = dict["help_button_cta_type"] as? String,
            let helpButtonCTAType = NotificationButton.CTAType(rawValue: helpButtonTypeRawValue),
            let helpButtonCTAPayload = dict["help_button_cta_payload"] as? String {
            guard type != .banner else {
                throw NAError.dataFormat(type: .noHelpButtonAllowedInNotification)
            }
            self.helpButton = NotificationButton(with: "", callToActionType: helpButtonCTAType, callToActionPayload: helpButtonCTAPayload)
        }

        self.timeout = dict["timeout"] as? String
        if let aotRaw = dict["always_on_top"] as? String {
            self.alwaysOnTop = aotRaw.lowercased() == "true"
        } else {
            self.alwaysOnTop = false
        }
        if let silentRaw = dict["silent"] as? String {
            self.silent = silentRaw.lowercased() == "true"
        } else {
            self.silent = false
        }

        super.init()
        switch type {
        case .popup, .banner:
            guard self.title != nil || self.subtitle != nil || self.accessoryView != nil else {
                throw NAError.dataFormat(type: .noInfoToShow)
            }
        case .onboarding:
            guard self.payload != nil else {
                throw NAError.dataFormat(type: .noInfoToShow)
            }
        }
    }

    static func loadOnboardingPayload(_ payload: String) throws -> OnboardingData? {
        if payload.isValidURL, let url = URL(string: payload) {
            return try OnboardingData(from: url)
        } else if FileManager.default.fileExists(atPath: payload) {
            return try OnboardingData(from: URL(fileURLWithPath: payload))
        } else {
            return try OnboardingData(from: payload)
        }
    }
    
    // MARK: - Codable protocol conformity - START
    
    enum NOCodingKeys: String, CodingKey {
        case identifier
        case type
        case barTitle
        case title
        case subtitle
        case iconPath
        case accessoryView
        case mainButton
        case secondaryButton
        case tertiaryButton
        case helpButton
        case timeout
        case alwaysOnTop
        case silent
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NOCodingKeys.self)
        
        self.identifier = UUID()
        let typeRawValue = try container.decode(String.self, forKey: .type)
        self.type = UIType(rawValue: typeRawValue) ?? .popup
        self.barTitle = try container.decodeIfPresent(String.self, forKey: .barTitle)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.iconPath = try container.decodeIfPresent(String.self, forKey: .iconPath)
        self.accessoryView = try container.decodeIfPresent(NotificationAccessoryElement.self, forKey: .accessoryView)
        self.mainButton = try container.decode(NotificationButton.self, forKey: .mainButton)
        self.secondaryButton = try container.decodeIfPresent(NotificationButton.self, forKey: .secondaryButton)
        self.tertiaryButton = try container.decodeIfPresent(NotificationButton.self, forKey: .tertiaryButton)
        self.helpButton = try container.decodeIfPresent(NotificationButton.self, forKey: .helpButton)
        self.timeout = try container.decodeIfPresent(String.self, forKey: .timeout)
        self.alwaysOnTop = try container.decodeIfPresent(Bool.self, forKey: .alwaysOnTop)
        self.silent = try container.decodeIfPresent(Bool.self, forKey: .silent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NOCodingKeys.self)
        
        try container.encode(self.type.rawValue, forKey: .type)
        try container.encodeIfPresent(self.barTitle, forKey: .barTitle)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.subtitle, forKey: .subtitle)
        try container.encodeIfPresent(self.iconPath, forKey: .iconPath)
        try container.encodeIfPresent(self.accessoryView, forKey: .accessoryView)
        try container.encode(self.mainButton, forKey: .mainButton)
        try container.encodeIfPresent(self.secondaryButton, forKey: .secondaryButton)
        try container.encodeIfPresent(self.tertiaryButton, forKey: .tertiaryButton)
        try container.encodeIfPresent(self.helpButton, forKey: .helpButton)
        try container.encodeIfPresent(self.timeout, forKey: .timeout)
        try container.encodeIfPresent(self.alwaysOnTop, forKey: .alwaysOnTop)
        try container.encodeIfPresent(self.silent, forKey: .silent)
    }
    
    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START
    
    public static var supportsSecureCoding: Bool = true
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.type.rawValue, forKey: NOCodingKeys.type.rawValue)
        if let barTitle = self.barTitle {
            coder.encode(barTitle, forKey: NOCodingKeys.barTitle.rawValue)
        }
        if let title = self.title {
            coder.encode(title, forKey: NOCodingKeys.title.rawValue)
        }
        if let subtitle = self.subtitle {
            coder.encode(subtitle, forKey: NOCodingKeys.subtitle.rawValue)
        }
        if let iconPath = self.iconPath {
            coder.encode(iconPath, forKey: NOCodingKeys.iconPath.rawValue)
        }
        if let accessoryView = self.accessoryView {
            coder.encode(accessoryView, forKey: NOCodingKeys.accessoryView.rawValue)
        }
        coder.encode(self.mainButton, forKey: NOCodingKeys.mainButton.rawValue)
        if let secondaryButton = self.secondaryButton {
            coder.encode(secondaryButton, forKey: NOCodingKeys.secondaryButton.rawValue)
        }
        if let tertiaryButton = self.tertiaryButton {
            coder.encode(tertiaryButton, forKey: NOCodingKeys.tertiaryButton.rawValue)
        }
        if let helpButton = self.helpButton {
            coder.encode(helpButton, forKey: NOCodingKeys.helpButton.rawValue)
        }
        if let timeout = self.timeout {
            coder.encode(timeout, forKey: NOCodingKeys.timeout.rawValue)
        }
        if let alwaysOnTop = self.alwaysOnTop {
            let number = NSNumber(booleanLiteral: alwaysOnTop)
            coder.encode(number, forKey: NOCodingKeys.alwaysOnTop.rawValue)
        }
        if let silent = self.silent {
            let number = NSNumber(booleanLiteral: silent)
            coder.encode(number, forKey: NOCodingKeys.silent.rawValue)
        }
    }
    
    public required init?(coder: NSCoder) {
        self.identifier = UUID()
        self.type = UIType(rawValue: coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.type.rawValue) as String? ?? "none") ?? .popup
        self.barTitle = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.barTitle.rawValue) as String?
        self.title = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.title.rawValue) as String?
        self.subtitle = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.subtitle.rawValue) as String?
        self.iconPath = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.iconPath.rawValue) as String?
        self.accessoryView = coder.decodeObject(of: NotificationAccessoryElement.self, forKey: NOCodingKeys.accessoryView.rawValue)
        self.mainButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.mainButton.rawValue)!
        self.secondaryButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.secondaryButton.rawValue)
        self.tertiaryButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.tertiaryButton.rawValue)
        self.helpButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.helpButton.rawValue)
        self.timeout = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.timeout.rawValue) as String?
        self.alwaysOnTop = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.alwaysOnTop.rawValue) as? Bool
        self.silent = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.silent.rawValue) as? Bool
    }
    
    // MARK: - NSSecureCoding protocol conformity - END
}
