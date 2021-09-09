//
//  AccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 03/05/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol AccessoryViewDelegate: AnyObject {
    func accessoryViewStatusDidChange(_ sender: AccessoryView)
}

/// The base accessory view class
class AccessoryView: NSView {
    enum ButtonState {
        case enabled
        case disabled
        case hidden
    }
    var mainButtonState: ButtonState = .enabled
    var secondaryButtonState: ButtonState = .enabled
    weak var delegate: AccessoryViewDelegate?
}
