//
//  NotificationObject.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/9/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable function_body_length type_body_length

import Foundation
import Cocoa

/// The object used to describe the received notification to be showed to the user.
public final class NotificationObject: NSObject, Codable, NSSecureCoding {

    // MARK: - Enums

    /// The allowed type of notification that can be showed.
    enum UIType: String {
        case popup // Popup window.
        case banner // Temporary user notification banner.
        case onboarding // Onboarding window.
        case alert // Persistent user notification banner.
    }

    // MARK: - Variables
    
    /// The identifier of the notification object.
    /// Used to better handle the answer of the user.
    var identifier: UUID
    /// Identifier needed to track the notification topic.
    var topicID: String
    /// Identifier needed to track the specific notification.
    var notificationID: String
    /// The type of the notification.
    var type: UIType
    /// The bar title for the "popup" UI type. Not used for "notification" UI type.
    var barTitle: String?
    /// The title of the notification.
    var title: String?
    /// The title's font size
    var titleFontSize: String?
    /// The subtitle of the notification.
    var subtitle: String?
    /// Custom icon path defined for this notification object (Available only for popup UIType).
    var iconPath: String?
    /// Custom notification alert/banner attachment (image). It supports remote link, local path and base64 encoded image.
    var notificationImage: String?
    /// The accessory views that needs to be added to the notification. This will be used only for "popup" notification type.
    var accessoryViews: [NotificationAccessoryElement]?
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
    /// The data needed for the "onboarding" UI type.
    var payload: OnboardingData?
    /// The desired pop-up window position on screen.
    var position: NSWindow.WindowPosition?
    /// A boolean value that define wheter the pop-up must be miniaturizable.
    var isMiniaturizable: Bool?
    /// A boolean value that define wheter the UI must be force in light mode.
    var forceLightMode: Bool?
    
    // MARK: - Initializers
    
    /// Create a NotificationObject starting from a dictionary of elements.
    /// - Parameter dictionary: the dictionary.
    /// - Throws: throws an error if the passed dictionary doesn't
    /// have all the info needed to build a NotificationObject.
    init(from dict: [String: Any]) throws {
        self.identifier = UUID()
        guard let typeRawValue = dict["type"] as? String,
              let type = UIType(rawValue: typeRawValue.lowercased()) else {
                throw NAError.dataFormat(type: .noTypeDefined)
        }
        self.type = type
        self.topicID = dict["topic_id"] as? String ?? "untracked"
        self.notificationID = dict["notification_id"] as? String ?? "untracked"
        self.barTitle = dict["bar_title"] as? String ?? ConfigurableParameters.defaultPopupBarTitle
        self.title = dict["title"] as? String
        self.titleFontSize = dict["title_size"] as? String
        self.subtitle = dict["subtitle"] as? String
        self.iconPath = dict["icon_path"] as? String ?? ConfigurableParameters.defaultPopupIconPath
        self.notificationImage = dict["notification_image"] as? String
        if let payloadRawData = dict["payload"] as? String {
            switch type {
            case .onboarding:
                self.payload = try? Self.loadOnboardingPayload(payloadRawData)
            default:
                break
            }
        }
        self.accessoryViews = []
        if let accessoryviewTyperawValue = dict["accessory_view_type"] as? String,
           let accessoryViewType = NotificationAccessoryElement.ViewType.init(rawValue: accessoryviewTyperawValue.lowercased()) {
            self.accessoryViews?.append(NotificationAccessoryElement(with: accessoryViewType, payload: dict["accessory_view_payload"] as? String))
        }
        
        if let secondaryAccessoryviewTyperawValue = dict["secondary_accessory_view_type"] as? String,
           let secondaryAccessoryViewType = NotificationAccessoryElement.ViewType.init(rawValue: secondaryAccessoryviewTyperawValue.lowercased()) {
            self.accessoryViews?.append(NotificationAccessoryElement(with: secondaryAccessoryViewType, payload: dict["secondary_accessory_view_payload"] as? String))
        }

        // Main button is mandatory so if not defined from who trigger the notification will be used a default one that show a default label and trigger no actions.
        let mainButtonLabel = dict["main_button_label"] as? String ?? ConfigurableParameters.defaultMainButtonLabel
        let mainButtonCTAType = NotificationButton.CTAType(rawValue: (dict["main_button_cta_type"] as? String ?? "none").lowercased()) ?? .none
        let mainButtonCTAPayload = (dict["main_button_cta_payload"] as? String) ?? ""
        self.mainButton = NotificationButton(with: mainButtonLabel, callToActionType: mainButtonCTAType, callToActionPayload: mainButtonCTAPayload)

        // Secondary button is not mandatory. If found the label but not the cta type and payload it will be set to "none".
        if let secondaryButtonLabel = dict["secondary_button_label"] as? String,
            let secondaryButtonCTAType = NotificationButton.CTAType(rawValue: (dict["secondary_button_cta_type"] as? String ?? "none").lowercased()) {
                self.secondaryButton = NotificationButton(with: secondaryButtonLabel, callToActionType: secondaryButtonCTAType, callToActionPayload: dict["secondary_button_cta_payload"] as? String ?? "")
        }

        if let tertiaryButtonLabel = dict["tertiary_button_label"] as? String,
            let tertiaryButtonCTATypeRawValue = dict["tertiary_button_cta_type"] as? String,
            let tertiaryButtonCTAType = NotificationButton.CTAType(rawValue: tertiaryButtonCTATypeRawValue.lowercased()),
            let tertiaryButtonCTAPayload = dict["tertiary_button_cta_payload"] as? String {
            self.tertiaryButton = NotificationButton(with: tertiaryButtonLabel, callToActionType: tertiaryButtonCTAType, callToActionPayload: tertiaryButtonCTAPayload)
        }

        if let helpButtonTypeRawValue = dict["help_button_cta_type"] as? String,
           let helpButtonCTAType = NotificationButton.CTAType(rawValue: helpButtonTypeRawValue.lowercased()),
            let helpButtonCTAPayload = dict["help_button_cta_payload"] as? String {
            guard type != .banner else {
                throw NAError.dataFormat(type: .noHelpButtonAllowedInNotification)
            }
            self.helpButton = NotificationButton(with: "", callToActionType: helpButtonCTAType, callToActionPayload: helpButtonCTAPayload)
        }

        self.timeout = dict["timeout"] as? String ?? ConfigurableParameters.defaultPopupTimeout?.description
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
        if let miniaturizableRaw = dict["miniaturizable"] as? String {
            self.isMiniaturizable = miniaturizableRaw.lowercased() == "true"
        } else {
            self.isMiniaturizable = false
        }
        if let forceLightModeRaw = dict["force_light_mode"] as? String {
            self.forceLightMode = forceLightModeRaw.lowercased() == "true"
        }
        if let positionRaw = dict["position"] as? String {
            self.position = NSWindow.WindowPosition(rawValue: positionRaw)
        }
        super.init()
        try checkObjectConsistency()
    }
    
    private func checkObjectConsistency() throws {
        switch type {
        case .popup, .banner, .alert:
            guard self.title != nil || self.subtitle != nil || !(self.accessoryViews?.isEmpty ?? true) else {
                throw NAError.dataFormat(type: .noInfoToShow)
            }
            if let title = self.title {
                switch title.count {
                case 121...240:
                    NALogger.shared.log("Title string is longer than the suggested 120 characters, it is %{public}@ characters long.", [title.count.description])
                case 241...:
                    NALogger.shared.log("Title string is longer than the allowed 240 characters, it is %{public}@ characters long, it will be hidden.", [title.count.description])
                    self.title = nil
                default:
                    break
                }
            }
        case .onboarding:
            guard self.payload != nil else {
                throw NAError.dataFormat(type: .invalidOnboardingPayload)
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
        case notificationID
        case topicID
        case type
        case barTitle
        case title
        case titleFontSize
        case subtitle
        case iconPath
        case notificationAttachment
        case accessoryViews
        case mainButton
        case secondaryButton
        case tertiaryButton
        case helpButton
        case timeout
        case alwaysOnTop
        case silent
        case position
        case miniaturizable
        case payload
        case forceLightMode
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NOCodingKeys.self)
        
        self.identifier = UUID()
        let typeRawValue = try container.decode(String.self, forKey: .type)
        self.type = UIType(rawValue: typeRawValue) ?? .popup
        self.topicID = try container.decode(String.self, forKey: .topicID)
        self.notificationID = try container.decode(String.self, forKey: .notificationID)
        self.barTitle = try container.decodeIfPresent(String.self, forKey: .barTitle)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.titleFontSize = try container.decodeIfPresent(String.self, forKey: .titleFontSize)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.iconPath = try container.decodeIfPresent(String.self, forKey: .iconPath)
        self.notificationImage = try container.decodeIfPresent(String.self, forKey: .notificationAttachment)
        self.accessoryViews = try container.decodeIfPresent([NotificationAccessoryElement].self, forKey: .accessoryViews)
        self.mainButton = try container.decode(NotificationButton.self, forKey: .mainButton)
        self.secondaryButton = try container.decodeIfPresent(NotificationButton.self, forKey: .secondaryButton)
        self.tertiaryButton = try container.decodeIfPresent(NotificationButton.self, forKey: .tertiaryButton)
        self.helpButton = try container.decodeIfPresent(NotificationButton.self, forKey: .helpButton)
        self.timeout = try container.decodeIfPresent(String.self, forKey: .timeout)
        self.alwaysOnTop = try container.decodeIfPresent(Bool.self, forKey: .alwaysOnTop)
        self.silent = try container.decodeIfPresent(Bool.self, forKey: .silent)
        self.isMiniaturizable = try container.decodeIfPresent(Bool.self, forKey: .miniaturizable)
        self.forceLightMode = try container.decodeIfPresent(Bool.self, forKey: .forceLightMode)
        self.payload = try container.decodeIfPresent(OnboardingData.self, forKey: .payload)
        if let positionRawValue = try container.decodeIfPresent(String.self, forKey: .position) {
            self.position = NSWindow.WindowPosition(rawValue: positionRawValue)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NOCodingKeys.self)
        
        try container.encode(self.type.rawValue, forKey: .type)
        try container.encodeIfPresent(self.barTitle, forKey: .barTitle)
        try container.encode(self.notificationID, forKey: .notificationID)
        try container.encode(self.topicID, forKey: .topicID)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.titleFontSize, forKey: .titleFontSize)
        try container.encodeIfPresent(self.subtitle, forKey: .subtitle)
        try container.encodeIfPresent(self.iconPath, forKey: .iconPath)
        try container.encodeIfPresent(self.notificationImage, forKey: .notificationAttachment)
        try container.encodeIfPresent(self.accessoryViews, forKey: .accessoryViews)
        try container.encode(self.mainButton, forKey: .mainButton)
        try container.encodeIfPresent(self.secondaryButton, forKey: .secondaryButton)
        try container.encodeIfPresent(self.tertiaryButton, forKey: .tertiaryButton)
        try container.encodeIfPresent(self.helpButton, forKey: .helpButton)
        try container.encodeIfPresent(self.timeout, forKey: .timeout)
        try container.encodeIfPresent(self.alwaysOnTop, forKey: .alwaysOnTop)
        try container.encodeIfPresent(self.silent, forKey: .silent)
        try container.encodeIfPresent(self.isMiniaturizable, forKey: .miniaturizable)
        try container.encodeIfPresent(self.forceLightMode, forKey: .forceLightMode)
        try container.encodeIfPresent(self.payload, forKey: .payload)
        try container.encodeIfPresent(self.position?.rawValue, forKey: .position)
    }
    
    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START
    
    public static var supportsSecureCoding: Bool = true
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.type.rawValue, forKey: NOCodingKeys.type.rawValue)
        coder.encode(self.notificationID, forKey: NOCodingKeys.notificationID.rawValue)
        coder.encode(self.topicID, forKey: NOCodingKeys.topicID.rawValue)
        if let barTitle = self.barTitle {
            coder.encode(barTitle, forKey: NOCodingKeys.barTitle.rawValue)
        }
        if let title = self.title {
            coder.encode(title, forKey: NOCodingKeys.title.rawValue)
        }
        if let titleFontSize = self.titleFontSize {
            coder.encode(titleFontSize, forKey: NOCodingKeys.titleFontSize.rawValue)
        }
        if let subtitle = self.subtitle {
            coder.encode(subtitle, forKey: NOCodingKeys.subtitle.rawValue)
        }
        if let iconPath = self.iconPath {
            coder.encode(iconPath, forKey: NOCodingKeys.iconPath.rawValue)
        }
        if let notificationAttachment = self.notificationImage {
            coder.encode(notificationAttachment, forKey: NOCodingKeys.notificationAttachment.rawValue)
        }
        if let accessoryViews = self.accessoryViews, !accessoryViews.isEmpty {
            coder.encode(accessoryViews, forKey: NOCodingKeys.accessoryViews.rawValue)
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
        if let isMiniaturizable = self.isMiniaturizable {
            let number = NSNumber(booleanLiteral: isMiniaturizable)
            coder.encode(number, forKey: NOCodingKeys.miniaturizable.rawValue)
        }
        if let forceLightMode = self.forceLightMode {
            let number = NSNumber(booleanLiteral: forceLightMode)
            coder.encode(number, forKey: NOCodingKeys.forceLightMode.rawValue)
        }
        if let position = self.position?.rawValue {
            coder.encode(position, forKey: NOCodingKeys.position.rawValue)
        }
    }
    
    public required init?(coder: NSCoder) {
        self.identifier = UUID()
        self.type = UIType(rawValue: coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.type.rawValue) as String? ?? "none") ?? .popup
        self.barTitle = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.barTitle.rawValue) as String?
        self.topicID = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.topicID.rawValue)! as String
        self.notificationID = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.notificationID.rawValue)! as String
        self.title = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.title.rawValue) as String?
        self.titleFontSize = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.titleFontSize.rawValue) as String?
        self.subtitle = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.subtitle.rawValue) as String?
        self.iconPath = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.iconPath.rawValue) as String?
        self.notificationImage = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.notificationAttachment.rawValue) as String?
        self.accessoryViews = coder.decodeObject(of: [NotificationAccessoryElement.self], forKey: NOCodingKeys.accessoryViews.rawValue) as? [NotificationAccessoryElement]
        self.mainButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.mainButton.rawValue)!
        self.secondaryButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.secondaryButton.rawValue)
        self.tertiaryButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.tertiaryButton.rawValue)
        self.helpButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.helpButton.rawValue)
        self.timeout = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.timeout.rawValue) as String?
        self.alwaysOnTop = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.alwaysOnTop.rawValue) as? Bool
        self.silent = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.silent.rawValue) as? Bool
        self.isMiniaturizable = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.miniaturizable.rawValue) as? Bool
        self.forceLightMode = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.forceLightMode.rawValue) as? Bool
        if let positionRawValue = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.position.rawValue) {
            self.position = NSWindow.WindowPosition(rawValue: positionRawValue as String)
        }
    }
    
    // MARK: - NSSecureCoding protocol conformity - END
}
