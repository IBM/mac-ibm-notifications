//
//  Context.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 31/03/2021.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// Application context
final class Context {
    
    static let main: Context = Context()

    // MARK: - Variables
    
    private var _sharedSettings: SharedSettings? {
        didSet {
            guard let newSettings = _sharedSettings else { return }
            UserDefaults.standard.set(newSettings.environment.rawValue, forKey: "environment")
        }
    }
    var sharedSettings: SharedSettings? {
        get {
            guard let settings = _sharedSettings else {
                return SharedSettings(isVerboseModeEnabled: false,
                                     environment: Environment.current)
            }
            return settings
        }
        set {
            _sharedSettings = newValue
        }
    }
    var backgroundPanelsController: BackPanelController?
    var disableQuit: Bool = false
}
