//
//  NSWindow-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 27/04/2021.
//  Copyright © 2021 IBM. All rights reserved.
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
        guard let mainScreen = NSScreen.main else {
            self.center()
            return
        }
        let minX = mainScreen.visibleFrame.minX + 30
        let minY = mainScreen.visibleFrame.minY + 30 + self.frame.size.height
        let maxX = mainScreen.visibleFrame.maxX - 30 - self.frame.size.width
        let maxY = mainScreen.visibleFrame.maxY - 30
        switch position {
        case .topRight:
            self.setFrameTopLeftPoint(CGPoint(x: maxX, y: maxY))
        case .topLeft:
            self.setFrameTopLeftPoint(CGPoint(x: minX, y: maxY))
        case .bottomLeft:
            self.setFrameTopLeftPoint(CGPoint(x: minX, y: minY))
        case .bottomRight:
            self.setFrameTopLeftPoint(CGPoint(x: maxX, y: minY))
        case .center:
            self.center()
        }
    }
}
