//
//  NSWScreen-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 27/04/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

extension NSScreen {
    struct ReservedInsets {
        let top: CGFloat
        let left: CGFloat
        let bottom: CGFloat
        let right: CGFloat
    }
    
    var reservedInsets: ReservedInsets {
        return ReservedInsets(top: max(0, frame.maxY - visibleFrame.maxY),
                              left: max(0, visibleFrame.minX - frame.minX),
                              bottom: max(0, visibleFrame.minY - frame.minY),
                              right: max(0, frame.maxX - visibleFrame.maxX))
    }
    
    enum DockPosition { case left, bottom, right }
    var dockPosition: DockPosition? {
        if reservedInsets.bottom > 0 { return .bottom }
        if reservedInsets.left > 0 { return .left }
        if reservedInsets.right > 0 { return .right }
        return nil
    }
    
    var isDockVisible: Bool {
        return reservedInsets.bottom > 0 || reservedInsets.left > 0 || reservedInsets.right > 0
    }
}
