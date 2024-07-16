//
//  View-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 06/02/23.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

extension View {
    func compatibleAccessibilityLabel(label: String) -> some View {
        return self.accessibilityLabel(label)
    }
}
