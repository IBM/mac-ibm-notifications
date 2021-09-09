//
//  NSColor-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 15/04/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

extension NSColor {
    var hexString: String {
        guard let rgbColor = usingColorSpace(NSColorSpace.deviceRGB) else {
            return "#FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
}
