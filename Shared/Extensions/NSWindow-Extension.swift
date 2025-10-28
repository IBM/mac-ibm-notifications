//
//  NSWindow-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 30/09/2025.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

extension NSWindow {
    enum WindowPosition: String, Codable {
        case topLeft = "top_left"
        case topRight = "top_right"
        case bottomLeft = "bottom_left"
        case bottomRight = "bottom_right"
        case center = "center"
    }
    
    func setWindowPosition(_ position: WindowPosition) {
        guard let screen = self.screen ?? NSScreen.main else {
            self.center()
            return
        }
        
        let size = self.frame.size
        let insets = screen.reservedInsets
        let margin: CGFloat = 30
        
        let xLeft = screen.frame.minX + insets.left + margin
        let xRight = screen.frame.maxX - insets.right - margin - size.width
        let yBottom = screen.frame.minY + insets.bottom + margin
        let yTop = screen.frame.maxY - insets.top - margin - size.height
        
        switch position {
        case .topRight:
            self.setFrameOrigin(NSPoint(x: xRight, y: yTop))
        case .topLeft:
            self.setFrameOrigin(NSPoint(x: xLeft, y: yTop))
        case .bottomLeft:
            self.setFrameOrigin(NSPoint(x: xLeft, y: yBottom))
        case .bottomRight:
            self.setFrameOrigin(NSPoint(x: xRight, y: yBottom))
        case .center:
            self.center()
        }
    }
}
