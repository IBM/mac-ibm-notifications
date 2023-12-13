//
//  PickerItem.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 15/12/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

struct PickerItem: Identifiable, Hashable {
    var id: Int
    var label: String
    var isSelected: Bool

    init(index: Int, label: String, isSelected: Bool) {
        self.id = index
        self.label = label
        self.isSelected = isSelected
    }
}
