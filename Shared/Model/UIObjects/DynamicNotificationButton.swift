//
//  DynamicNotificationButton.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 23/06/22.
//  Copyright © 2022 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

protocol DynamicNotificationButtonDelegate: AnyObject {
    func didReceivedNewStateForWarningButton(_ isVisible: Bool, isExpanded: Bool)
}

/// This struct describe a button that can be added to the view showed to the user.
/// This button provides APIs to be set visible or hidden dynamically.
public class DynamicNotificationButton: NotificationButton, InteractiveObjectProtocol {
    
    // MARK: - Variables
    
    /// Button's delegate.
    weak var delegate: DynamicNotificationButtonDelegate?
    /// Boolean values that describe the button appearance.
    var isVisible: Bool
    var isExpanded: Bool
    
    // MARK: - Initializers

    init(with label: String, callToActionType: CTAType, callToActionPayload: String, isVisible: Bool = true) {
        self.isVisible = isVisible
        self.isExpanded = false
        super.init(with: label, callToActionType: callToActionType, callToActionPayload: callToActionPayload)
    }
    
    // MARK: - InteractiveObjectProtocol protocol conformity - START

    var objectIdentifier: String = "dynamic_button_updates"

    func processInput(_ notification: Notification) {
        guard let inputData = notification.userInfo?["data"] as? Data else { return }
        if !inputData.isEmpty {
            guard let strData = String(data: inputData, encoding: String.Encoding.utf8)?.trimmingCharacters(in: CharacterSet.newlines) else { return }
            let splittedStrings = strData.split(separator: "/")
            for string in splittedStrings {
                guard let argument = string.split(separator: " ", maxSplits: 1).first?.lowercased(),
                      var value = string.split(separator: " ", maxSplits: 1).last else { continue }
                if value.last == " " {
                    value.removeLast()
                }
                switch argument {
                case "warning_button_visibility":
                    switch value {
                    case "hidden":
                        self.isExpanded = false
                        self.isVisible = false
                    case "visible":
                        self.isExpanded = false
                        self.isVisible = true
                    case "expand":
                        self.isExpanded = true
                        self.isVisible = true
                    default:
                        continue
                    }
                default:
                    continue
                }
            }
            self.delegate?.didReceivedNewStateForWarningButton(self.isVisible, isExpanded: self.isExpanded)
        }
    }
    
    // MARK: - InteractiveObjectProtocol protocol conformity - START
    // MARK: - Codable protocol conformity - START

    enum DNBCodingKeys: String, CodingKey {
        case isVisible
        case isExpanded
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DNBCodingKeys.self)
        
        self.isVisible = try container.decode(Bool.self, forKey: .isVisible)
        self.isExpanded = try container.decode(Bool.self, forKey: .isExpanded)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DNBCodingKeys.self)
        
        try container.encode(self.isVisible, forKey: .isVisible)
        try container.encode(self.isExpanded, forKey: .isExpanded)
        try super.encode(to: encoder)
    }
    
    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START
    
    public override func encode(with coder: NSCoder) {
        let isVisibleNumber = NSNumber(booleanLiteral: isVisible)
        coder.encode(isVisibleNumber, forKey: DNBCodingKeys.isVisible.rawValue)
        let isExpandedNumber = NSNumber(booleanLiteral: isExpanded)
        coder.encode(isExpandedNumber, forKey: DNBCodingKeys.isExpanded.rawValue)
        super.encode(with: coder)
    }

    public required init?(coder: NSCoder) {
        self.isVisible = coder.decodeObject(of: NSNumber.self, forKey: DNBCodingKeys.isVisible.rawValue) as? Bool ?? false
        self.isExpanded = coder.decodeObject(of: NSNumber.self, forKey: DNBCodingKeys.isExpanded.rawValue) as? Bool ?? false
        super.init(coder: coder)
    }

    // MARK: - NSSecureCoding protocol conformity - END
    
}
