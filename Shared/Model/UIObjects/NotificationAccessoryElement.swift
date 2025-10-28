//
//  NotificationAccessoryElement.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/9/20.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This struct describe an accessory view that needs to be displayed inside a popup.
public class NotificationAccessoryElement: NSObject, Codable, NSSecureCoding {

    // MARK: Enums

    /// The type of the accessory view could be:
    /// - whitebox: a text box with a white backgound.
    /// - timer: a label with a countdown for the user.
    /// - progressbar: an undefinied progressbar with a label.
    /// - image: an image.
    /// - video: a video.
    /// - input: an input field with a placeholder.
    /// - securedinput/secureinput: a secure input field with a placeholder.
    /// - dropdown: a drop down menu with multiple options
    /// - html: a view able to handle an html payload
    /// - htmlwhitebox: a view able to handle an html payload on a white background
    /// - checklist: a list of checkboxes
    /// - datepicker: a date picker view
    enum ViewType: String {
        case whitebox
        case timer
        case progressbar
        case image
        case video
        case input
        case securedinput // Deprecated
        case secureinput
        case dropdown
        case html
        case htmlwhitebox
        case checklist
        case datepicker
        case slideshow
    }

    // MARK: - Variables
    
    /// A unique ID to identify the accessory view between multiple with the same payload/type.
    var id: UUID = UUID()
    /// The type of the accessory view.
    var type: ViewType
    /// The payload for the accessory view. Based on the type of the view it could be:
    /// - text, whitebox: the string to be showed or a string key.
    /// - timer: the amount of seconds for the countdown.
    /// - progressbar: TBD.
    var payload: String?
    var media: NAMedia?

    // MARK: - Initializers

    init(with type: ViewType, payload: String?) {
        self.type = type
        self.payload = payload
        guard let mediaType = NAMedia.MediaType(rawValue: type.rawValue), let payload = payload else { return }
        self.media = NAMedia(type: mediaType, from: payload)
    }

    // MARK: - Codable protocol conformity - START

    enum NAVCodingKeys: String, CodingKey {
        case type
        case payload
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NAVCodingKeys.self)

        let typeRawValue = try container.decode(String.self, forKey: .type)
        let type = ViewType(rawValue: typeRawValue) ?? .whitebox
        let payload = try container.decodeIfPresent(String.self, forKey: .payload)
        self.init(with: type, payload: payload)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NAVCodingKeys.self)

        try container.encode(self.type.rawValue, forKey: .type)
        try container.encodeIfPresent(self.payload, forKey: .payload)
    }

    // MARK: Codable protocol conformity - END
    // MARK: - NSSecureCoding protocol conformity - START

    public static var supportsSecureCoding: Bool = true

    public func encode(with coder: NSCoder) {
        coder.encode(self.type.rawValue, forKey: NAVCodingKeys.type.rawValue)
        coder.encode(self.payload, forKey: NAVCodingKeys.payload.rawValue)
    }

    public required init?(coder: NSCoder) {
        self.type = ViewType(rawValue: coder.decodeObject(of: NSString.self, forKey: NAVCodingKeys.type.rawValue) as String? ?? "") ?? .whitebox
        self.payload = coder.decodeObject(of: NSString.self, forKey: NAVCodingKeys.payload.rawValue) as String? ?? ""
    }

    // MARK: - NSSecureCoding protocol conformity - END
}
