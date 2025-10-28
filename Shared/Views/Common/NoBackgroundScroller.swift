//
//  NoBackgroundScroller.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 30/04/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// NSScroller without background
class NoBackgroundScroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
        self.drawKnob()
    }
    
    override func mouseEntered(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.1
            self.animator().alphaValue = 0.85
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.15
            self.animator().alphaValue = 0.35
        }
    }
}
