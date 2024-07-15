//
//  Data-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 06/12/2023.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension Data {
    /// Boolean value that tells if the current data represent a GIF.
    /// Use this only if you're sure that the data represent an image.
    var isGIF: Bool {
        guard self.count > 3 else {
            return false
        }
        let gifSignature = "GIF".data(using: .ascii)
        return self.prefix(3) == gifSignature
    }
}
