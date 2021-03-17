//
//  ConfigurableParameter.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 9/10/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This class provide all the configurable variables available for the agent.
public final class ConfigurableParameters {
    static let set = ["default_popup_bar_title": "NADefaultPopupBarTitle",
                      "default_popup_icon_path": "NADefaultPopupIconPath",
                      "default_popup_timeout": "NADefaultPopupTimeout",
                      "default_main_button_label": "NADefaultMainButtonLabel"]
    /// The default main button label.
    /// By default this string is defined in the Localizable.strings files.
    static var defaultMainButtonLabel: String {
        if let userDefaultsValue = UserDefaults.standard.string(forKey: "NADefaultMainButtonLabel"),
            !userDefaultsValue.isEmpty {
            return userDefaultsValue
        }
        return "default_main_button_label".localized
    }
    /// The default timeout for the popup in seconds.
    /// By default no timeout is set.
    static var defaultPopupTimeout: Int? {
        if let timeoutString = UserDefaults.standard.string(forKey: "NADefaultPopupTimeout") {
            return Int(timeoutString)
        }
        return nil
    }
    /// The default bar title for the popup.
    /// By default this string is defined in the Localizable.strings files.
    static var defaultPopupBarTitle: String {
        if let userDefaultsValue = UserDefaults.standard.string(forKey: "NADefaultPopupBarTitle"),
            !userDefaultsValue.isEmpty {
            return userDefaultsValue
        }
        return "default_popup_bar_title".localized
    }
    /// The default path for the popup icon.
    /// By default the agent take it from it's assets.
    static var defaultPopupIconPath: String? {
        if let defaultPath = UserDefaults.standard.string(forKey: "NADefaultPopupIconPath"),
            !defaultPath.isEmpty {
            return defaultPath
        }
        return nil
    }
}
