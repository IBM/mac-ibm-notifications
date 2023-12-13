//
//  NotificationObject.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/9/20.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable type_body_length file_length

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
        case systemalert // Standard system Alert pop-up.
    }
    
    /// A set of predefined workflow
    enum PredefinedWorkflow: String {
        case resetBanners // Delete all the Notification Center banners
        case resetAlerts // Delete all the Notification Center alerts
    }
    
    /// Available styles for the background panel
    enum BackgroundPanelStyle: String {
        case translucent
        case opaque
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
    /// Custom icon width
    var iconWidth: String?
    /// Custom icon height
    var iconHeight: String?
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
    /// The warning button of the notification that needs to be showed to the user.
    /// For this button the label value will be ignored since the button is represented by a question mark icon.
    var warningButton: DynamicNotificationButton?
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
    /// The payload with the configuration of the pop-up reminder if set.
    var popupReminder: PopupReminder?
    /// A boolean value that define wheter the onboarding must show the title bar buttons.
    var hideTitleBarButtons: Bool?
    /// A boolean value that define if to print the available accessory view outputs on the secondary button click.
    var retainValues: Bool?
    /// A boolean value that define if to show the suppress notification checkbox on the systemAlert UI. Works only with systemAlert UI type.
    var showSuppressionButton: Bool?
    /// If defined the app should just run the predefined workflow
    var workflow: PredefinedWorkflow?
    /// The style of the background panel that will cover the entire screen.
    var backgroundPanel: BackgroundPanelStyle?
    /// A boolean value that define if the UI should be movable for the user.
    var isMovable: Bool = true
    /// A boolean value that define if the UI should ignore cmd+q shortcut.
    var disableQuit: Bool = false
    /// Custom width for the pop-up window size.
    var customWidth: String?
    ///  A boolean value that defined if the UI should appear without any destructive CTA.
    var buttonless: Bool = false
    
    // MARK: - Initializers
    
    //  swiftlint:disable function_body_length
    
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
        self.iconWidth = dict["icon_width"] as? String
        self.iconHeight = dict["icon_height"] as? String
        if let payloadRawData = dict["payload"] as? String {
            switch type {
            case .onboarding:
                self.payload = try Self.loadOnboardingPayload(payloadRawData)
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
        var mainButtonCTAType = NotificationButton.CTAType(rawValue: (dict["main_button_cta_type"] as? String ?? "none").lowercased()) ?? .none
        mainButtonCTAType = mainButtonCTAType == .link ? .exitlink : mainButtonCTAType
        let mainButtonCTAPayload = (dict["main_button_cta_payload"] as? String) ?? ""
        self.mainButton = NotificationButton(with: mainButtonLabel, callToActionType: mainButtonCTAType, callToActionPayload: mainButtonCTAPayload)

        // Secondary button is not mandatory. If found the label but not the cta type and payload it will be set to "none".
        if let secondaryButtonLabel = dict["secondary_button_label"] as? String,
            let secondaryButtonCTAType = NotificationButton.CTAType(rawValue: (dict["secondary_button_cta_type"] as? String ?? "none").lowercased()) {
            self.secondaryButton = NotificationButton(with: secondaryButtonLabel, callToActionType: secondaryButtonCTAType == .link ? .exitlink : secondaryButtonCTAType, callToActionPayload: dict["secondary_button_cta_payload"] as? String ?? "")
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
            guard type != .banner && type != .alert else {
                throw NAError.dataFormat(type: .noHelpButtonAllowedInNotification)
            }
            self.helpButton = NotificationButton(with: "", callToActionType: helpButtonCTAType, callToActionPayload: helpButtonCTAPayload)
        }
        
        if let warningButtonTypeRawValue = dict["warning_button_cta_type"] as? String,
           let warningButtonCTAType = NotificationButton.CTAType(rawValue: warningButtonTypeRawValue.lowercased()),
            let warningButtonCTAPayload = dict["warning_button_cta_payload"] as? String {
            guard type != .banner && type != .alert else {
                throw NAError.dataFormat(type: .noHelpButtonAllowedInNotification)
            }
            let isHidden = (dict["warning_button_visibility"] as? String ?? "visible") == "hidden"
            self.warningButton = DynamicNotificationButton(with: "", callToActionType: warningButtonCTAType, callToActionPayload: warningButtonCTAPayload, isVisible: !isHidden)
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
        if let hideTitleBarButtons = dict["hide_title_bar_buttons"] as? String {
            self.hideTitleBarButtons = hideTitleBarButtons.lowercased() == "true"
        } else {
            self.hideTitleBarButtons = false
        }
        if let forceLightModeRaw = dict["force_light_mode"] as? String {
            self.forceLightMode = forceLightModeRaw.lowercased() == "true"
        } else {
            self.forceLightMode = false
        }
        if let retainValuesRaw = dict["retain_values"] as? String {
            self.retainValues = retainValuesRaw.lowercased() == "true"
        } else {
            self.retainValues = false
        }
        if let showSuppressionButtonRaw = dict["show_suppression_button"] as? String {
            self.showSuppressionButton = showSuppressionButtonRaw.lowercased() == "true"
        } else {
            self.showSuppressionButton = false
        }
        if let positionRaw = dict["position"] as? String {
            self.position = NSWindow.WindowPosition(rawValue: positionRaw)
        }
        if let popupReminderPayload = dict["popup_reminder"] as? String {
            let popupReminderObj = try PopupReminder(with: popupReminderPayload)
            self.popupReminder = popupReminderObj
        }
        if let workflowRawValue = dict["workflow"] as? String {
            self.workflow = PredefinedWorkflow(rawValue: workflowRawValue)
        }
        if let backgroundPanelRawValue = dict["background_panel"] as? String {
            self.backgroundPanel = BackgroundPanelStyle(rawValue: backgroundPanelRawValue)
        }
        if let isNotMovable = dict["unmovable"] as? String {
            self.isMovable = !(isNotMovable.lowercased() == "true")
        }
        if let disableQuit = dict["disable_quit"] as? String {
            self.disableQuit = disableQuit.lowercased() == "true"
        }
        self.customWidth = dict["custom_width"] as? String
        if let buttonless = dict["buttonless"] as? String {
            self.buttonless = buttonless.lowercased() == "true"
        }
        super.init()
        try checkObjectConsistency()
    }
        
    private func checkObjectConsistency() throws {
        switch type {
        case .popup, .banner, .alert, .systemalert:
            guard self.title != nil || self.subtitle != nil || !(self.accessoryViews?.isEmpty ?? true) || self.workflow != nil else {
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
            func resetCustomIconSize(_ message: String) {
                NALogger.shared.log("%{public}@", [message])
                iconWidth = nil
                iconHeight = nil
            }
            if let iconWidthAsString = iconWidth {
                if let customWidth = NumberFormatter().number(from: iconWidthAsString) {
                    if CGFloat(truncating: customWidth) > 150 {
                        resetCustomIconSize("The desired custom icon size exceed the limits (Width: 150px, Height: 300px)")
                    }
                } else {
                    resetCustomIconSize("Please check the format of -icon_width argument.")
                }
            }
            if let iconHeightAsString = iconHeight {
                if let customHeight = NumberFormatter().number(from: iconHeightAsString) {
                    if CGFloat(truncating: customHeight) > 300 {
                        resetCustomIconSize("The desired custom icon size exceed the limits (Width: 150px, Height: 300px)")
                    }
                } else {
                    resetCustomIconSize("Please check the format of -icon_height argument.")
                }
            }
            func resetCustomSize(_ message: String) {
                NALogger.shared.log("%{public}@", [message])
                customWidth = nil
            }
            if let customWidthAsString = customWidth {
                if let customWidthNumber = NumberFormatter().number(from: customWidthAsString) {
                    let customWidth = CGFloat(truncating: customWidthNumber)
                    if let screenWidth = NSScreen.main?.visibleFrame.size.width, customWidth > screenWidth {
                        resetCustomSize("The desired window custom width exceed the current main display width.")
                    }
                    if customWidth < 520 {
                        resetCustomSize("It's not allowed to define window's custom width lower than the standard one.")
                    }
                } else {
                    resetCustomSize("Please check the format of -custom_width argument.")
                }
            }
        case .onboarding:
            guard self.payload != nil || self.workflow != nil else {
                throw NAError.dataFormat(type: .invalidOnboardingPayload)
            }
        }
    }

    //  swiftlint:enable function_body_length

    static func loadOnboardingPayload(_ payload: String) throws -> OnboardingData {
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
        case iconWidth
        case iconHeight
        case accessoryViews
        case mainButton
        case secondaryButton
        case tertiaryButton
        case helpButton
        case warningButton
        case timeout
        case alwaysOnTop
        case silent
        case position
        case miniaturizable
        case payload
        case forceLightMode
        case popupReminder
        case hideTitleBarButtons
        case retainValues
        case showSuppressionButton
        case workflow
        case backgroundPanel
        case isMovable
        case disableQuit
        case customWidth
        case buttonless
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
        self.iconWidth = try container.decodeIfPresent(String.self, forKey: .iconWidth)
        self.iconHeight = try container.decodeIfPresent(String.self, forKey: .iconHeight)
        self.notificationImage = try container.decodeIfPresent(String.self, forKey: .notificationAttachment)
        self.accessoryViews = try container.decodeIfPresent([NotificationAccessoryElement].self, forKey: .accessoryViews)
        self.mainButton = try container.decode(NotificationButton.self, forKey: .mainButton)
        self.secondaryButton = try container.decodeIfPresent(NotificationButton.self, forKey: .secondaryButton)
        self.tertiaryButton = try container.decodeIfPresent(NotificationButton.self, forKey: .tertiaryButton)
        self.helpButton = try container.decodeIfPresent(NotificationButton.self, forKey: .helpButton)
        self.warningButton = try container.decodeIfPresent(DynamicNotificationButton.self, forKey: .warningButton)
        self.timeout = try container.decodeIfPresent(String.self, forKey: .timeout)
        self.alwaysOnTop = try container.decodeIfPresent(Bool.self, forKey: .alwaysOnTop)
        self.silent = try container.decodeIfPresent(Bool.self, forKey: .silent)
        self.isMiniaturizable = try container.decodeIfPresent(Bool.self, forKey: .miniaturizable)
        self.hideTitleBarButtons = try container.decodeIfPresent(Bool.self, forKey: .hideTitleBarButtons)
        self.forceLightMode = try container.decodeIfPresent(Bool.self, forKey: .forceLightMode)
        self.retainValues = try container.decodeIfPresent(Bool.self, forKey: .retainValues)
        self.showSuppressionButton = try container.decodeIfPresent(Bool.self, forKey: .showSuppressionButton)
        self.payload = try container.decodeIfPresent(OnboardingData.self, forKey: .payload)
        if let positionRawValue = try container.decodeIfPresent(String.self, forKey: .position) {
            self.position = NSWindow.WindowPosition(rawValue: positionRawValue)
        }
        self.popupReminder = try container.decodeIfPresent(PopupReminder.self, forKey: .popupReminder)
        if let workflowRawValue = try container.decodeIfPresent(String.self, forKey: .workflow) {
            self.workflow = PredefinedWorkflow(rawValue: workflowRawValue)
        }
        if let backgroundPanelRawValue = try container.decodeIfPresent(String.self, forKey: .backgroundPanel) {
            self.backgroundPanel = BackgroundPanelStyle(rawValue: backgroundPanelRawValue)
        }
        self.isMovable = try container.decode(Bool.self, forKey: .isMovable)
        self.disableQuit = try container.decode(Bool.self, forKey: .disableQuit)
        self.customWidth = try container.decodeIfPresent(String.self, forKey: .customWidth)
        self.buttonless = try container.decode(Bool.self, forKey: .buttonless)
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
        try container.encodeIfPresent(self.iconWidth, forKey: .iconWidth)
        try container.encodeIfPresent(self.iconHeight, forKey: .iconHeight)
        try container.encodeIfPresent(self.accessoryViews, forKey: .accessoryViews)
        try container.encode(self.mainButton, forKey: .mainButton)
        try container.encodeIfPresent(self.secondaryButton, forKey: .secondaryButton)
        try container.encodeIfPresent(self.tertiaryButton, forKey: .tertiaryButton)
        try container.encodeIfPresent(self.helpButton, forKey: .helpButton)
        try container.encodeIfPresent(self.warningButton, forKey: .warningButton)
        try container.encodeIfPresent(self.timeout, forKey: .timeout)
        try container.encodeIfPresent(self.alwaysOnTop, forKey: .alwaysOnTop)
        try container.encodeIfPresent(self.silent, forKey: .silent)
        try container.encodeIfPresent(self.isMiniaturizable, forKey: .miniaturizable)
        try container.encodeIfPresent(self.hideTitleBarButtons, forKey: .hideTitleBarButtons)
        try container.encodeIfPresent(self.forceLightMode, forKey: .forceLightMode)
        try container.encodeIfPresent(self.retainValues, forKey: .retainValues)
        try container.encodeIfPresent(self.showSuppressionButton, forKey: .showSuppressionButton)
        try container.encodeIfPresent(self.payload, forKey: .payload)
        try container.encodeIfPresent(self.position?.rawValue, forKey: .position)
        try container.encodeIfPresent(self.popupReminder, forKey: .popupReminder)
        try container.encodeIfPresent(self.workflow?.rawValue, forKey: .workflow)
        try container.encodeIfPresent(self.backgroundPanel?.rawValue, forKey: .backgroundPanel)
        try container.encodeIfPresent(self.isMovable, forKey: .isMovable)
        try container.encodeIfPresent(self.disableQuit, forKey: .disableQuit)
        try container.encodeIfPresent(self.customWidth, forKey: .customWidth)
        try container.encodeIfPresent(self.buttonless, forKey: .buttonless)
    }
    
    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START
    
    public static var supportsSecureCoding: Bool = true
    
    //  swiftlint:disable function_body_length

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
        if let iconWidth = self.iconWidth {
            coder.encode(iconWidth, forKey: NOCodingKeys.iconWidth.rawValue)
        }
        if let iconHeight = self.iconHeight {
            coder.encode(iconHeight, forKey: NOCodingKeys.iconHeight.rawValue)
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
        if let warningButton = self.warningButton {
            coder.encode(warningButton, forKey: NOCodingKeys.warningButton.rawValue)
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
        if let hideTitleBarButtons = self.hideTitleBarButtons {
            let number = NSNumber(booleanLiteral: hideTitleBarButtons)
            coder.encode(number, forKey: NOCodingKeys.hideTitleBarButtons.rawValue)
        }
        if let forceLightMode = self.forceLightMode {
            let number = NSNumber(booleanLiteral: forceLightMode)
            coder.encode(number, forKey: NOCodingKeys.forceLightMode.rawValue)
        }
        if let retainValues = self.retainValues {
            let number = NSNumber(booleanLiteral: retainValues)
            coder.encode(number, forKey: NOCodingKeys.retainValues.rawValue)
        }
        if let showSuppressionButton = self.showSuppressionButton {
            let number = NSNumber(booleanLiteral: showSuppressionButton)
            coder.encode(number, forKey: NOCodingKeys.showSuppressionButton.rawValue)
        }
        if let position = self.position?.rawValue {
            coder.encode(position, forKey: NOCodingKeys.position.rawValue)
        }
        if let popupReminder = self.popupReminder {
            coder.encode(popupReminder, forKey: NOCodingKeys.popupReminder.rawValue)
        }
        if let workflowRawValue = self.workflow?.rawValue {
            coder.encode(workflowRawValue, forKey: NOCodingKeys.workflow.rawValue)
        }
        if let backgroundPanelRawValue = self.backgroundPanel?.rawValue {
            coder.encode(backgroundPanelRawValue, forKey: NOCodingKeys.backgroundPanel.rawValue)
        }
        let nIsMovable = NSNumber(booleanLiteral: isMovable)
        coder.encode(nIsMovable, forKey: NOCodingKeys.isMovable.rawValue)
        let nDisableQuit = NSNumber(booleanLiteral: disableQuit)
        coder.encode(nDisableQuit, forKey: NOCodingKeys.disableQuit.rawValue)
        if let customWidth = self.customWidth {
            coder.encode(customWidth, forKey: NOCodingKeys.customWidth.rawValue)
        }
        let nButtonless = NSNumber(booleanLiteral: buttonless)
        coder.encode(nButtonless, forKey: NOCodingKeys.buttonless.rawValue)
    }
    
    //  swiftlint:enable function_body_length
    
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
        self.iconWidth = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.iconWidth.rawValue) as String?
        self.iconHeight = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.iconHeight.rawValue) as String?
        self.accessoryViews = coder.decodeObject(of: [NotificationAccessoryElement.self], forKey: NOCodingKeys.accessoryViews.rawValue) as? [NotificationAccessoryElement]
        self.mainButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.mainButton.rawValue)!
        self.secondaryButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.secondaryButton.rawValue)
        self.tertiaryButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.tertiaryButton.rawValue)
        self.helpButton = coder.decodeObject(of: NotificationButton.self, forKey: NOCodingKeys.helpButton.rawValue)
        self.warningButton = coder.decodeObject(of: DynamicNotificationButton.self, forKey: NOCodingKeys.warningButton.rawValue)
        self.timeout = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.timeout.rawValue) as String?
        self.alwaysOnTop = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.alwaysOnTop.rawValue) as? Bool
        self.silent = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.silent.rawValue) as? Bool
        self.isMiniaturizable = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.miniaturizable.rawValue) as? Bool
        self.hideTitleBarButtons = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.hideTitleBarButtons.rawValue) as? Bool
        self.forceLightMode = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.forceLightMode.rawValue) as? Bool
        self.retainValues = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.retainValues.rawValue) as? Bool
        self.showSuppressionButton = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.showSuppressionButton.rawValue) as? Bool
        if let positionRawValue = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.position.rawValue) {
            self.position = NSWindow.WindowPosition(rawValue: positionRawValue as String)
        }
        self.popupReminder = coder.decodeObject(of: PopupReminder.self, forKey: NOCodingKeys.popupReminder.rawValue)
        if let workflowRawValue = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.workflow.rawValue) {
            self.workflow = PredefinedWorkflow(rawValue: workflowRawValue as String)
        }
        if let backgroundPanelRawValue = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.backgroundPanel.rawValue) {
            self.backgroundPanel = BackgroundPanelStyle(rawValue: backgroundPanelRawValue as String)
        }
        self.isMovable = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.isMovable.rawValue) as? Bool ?? true
        self.disableQuit = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.disableQuit.rawValue) as? Bool ?? false
        self.customWidth = coder.decodeObject(of: NSString.self, forKey: NOCodingKeys.customWidth.rawValue) as String?
        self.buttonless = coder.decodeObject(of: NSNumber.self, forKey: NOCodingKeys.buttonless.rawValue) as? Bool ?? false
    }
    
    // MARK: - NSSecureCoding protocol conformity - END
}

//  swiftlint:enable type_body_length file_length
