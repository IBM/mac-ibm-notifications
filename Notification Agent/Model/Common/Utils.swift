//
//  Utils.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 9/24/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

struct Utils {
    enum InterfaceStyle: String {
        case dark = "Dark"
        case light = "Light"

        init() {
            let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
            self = InterfaceStyle(rawValue: type)!
        }
    }
    static var currentInterfaceStyle: InterfaceStyle {
        return InterfaceStyle()
    }
}
