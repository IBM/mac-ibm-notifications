//
//  FlippedStackView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 01/05/2021.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// A flipped stackview
class FlippedStackView: NSStackView {
    override var isFlipped: Bool {
        return true
    }
}
