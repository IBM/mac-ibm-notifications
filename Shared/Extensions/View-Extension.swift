//
//  View-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 06/02/23.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

extension View {
    func compatibleAccessibilityLabel(label: String) -> some View {
        return self.accessibilityLabel(label)
    }
}
