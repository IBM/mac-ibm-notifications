//
//  HorizontalLine.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 3/17/20.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This class provide a simple horizontal line.
class HorizontalLine: NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.darkGray.set()
        NSRect(x: 0, y: 0, width: dirtyRect.width, height: 1).fill()
    }
}
