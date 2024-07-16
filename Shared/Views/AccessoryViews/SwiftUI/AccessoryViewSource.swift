//
//  AccessoryViewSource.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 11/05/2023.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

struct AccessoryViewSource {
    // A binding to a String that is used to keep track of the accessory view output.
    @Binding var output: String
    /// A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    @Binding var mainButtonState: SwiftUIButtonState
    /// A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    @Binding var secondaryButtonState: SwiftUIButtonState
    
    var accessoryView: NotificationAccessoryElement
    var viewModel: AccessoryViewController?
    
    init(output: Binding<String>, mainButtonState: Binding<SwiftUIButtonState>, secondaryButtonState: Binding<SwiftUIButtonState>, accessoryView: NotificationAccessoryElement, viewModel: AccessoryViewController? = nil) {
        self._output = output
        self._mainButtonState = mainButtonState
        self._secondaryButtonState = secondaryButtonState
        self.accessoryView = accessoryView
        if accessoryView.type == .progressbar {
            self.viewModel = ProgressBarViewModel(progressState: ProgressState(accessoryView.payload ?? ""),
                                                  mainButtonState: mainButtonState,
                                                  secondaryButtonState: secondaryButtonState)
        } else {
            self.viewModel = viewModel
        }
    }
}

extension AccessoryViewSource: Equatable {
    static func == (lhs: AccessoryViewSource, rhs: AccessoryViewSource) -> Bool {
        return lhs.accessoryView == rhs.accessoryView
    }
}

extension AccessoryViewSource: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.accessoryView)
    }
}
