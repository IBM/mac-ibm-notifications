//
//  AccessoryViewWrapper.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 09/02/23.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import Combine
import RichText

/// AccessoryViewWrapper is a struct that define a view that works as generic wrapper for all the available Accessory Views.
struct AccessoryViewWrapper: View {

    // MARK: - Variables
    
    var source: AccessoryViewSource
    var contentMode: ContentMode = .fill

    // MARK: - Views
    
    var body: some View {
        switch source.accessoryView.type {
        case .secureinput, .securedinput, .input:
            try? InputView(source.accessoryView.payload ?? "", output: source.$output, mainButtonState: source.$mainButtonState, secondaryButtonState: source.$secondaryButtonState, legacyType: source.accessoryView.type)
                .accessibilityIdentifier(source.accessoryView.type == .input ? "input_accessory_view" : "secure_input_accessory_view")
        case .checklist, .dropdown:
            try? PickerView(source.accessoryView.payload ?? "", output: source.$output, mainButtonState: source.$mainButtonState, secondaryButtonState: source.$secondaryButtonState, legacyType: source.accessoryView.type)
                .accessibilityIdentifier(source.accessoryView.type == .checklist ? "checklist_accessory_view" : "dropdown_whitebox_accessory_view")
        case .image, .video:
            try? MediaView(source.accessoryView.payload ?? "", output: source.$output, mainButtonState: source.$mainButtonState, secondaryButtonState: source.$secondaryButtonState, legacyType: source.accessoryView.type, contentMode: contentMode)
                .accessibilityIdentifier(source.accessoryView.type == .image ? "image_accessory_view" : "video_whitebox_accessory_view")
        case .html, .htmlwhitebox:
            ZStack {
                if source.accessoryView.type == .htmlwhitebox {
                    Color.white
                }
                ScrollView {
                    RichText(html: source.accessoryView.payload ?? "")
                        .colorScheme(source.accessoryView.type == .htmlwhitebox ? .light : .auto)
                        .padding(source.accessoryView.type == .htmlwhitebox ? 4 : 0)
                }
                .frame(maxHeight: AppComponent.current == .popup ? 300 : .infinity)
                .fixedSize(horizontal: false, vertical: true)
            }
        case .whitebox:
            MarkdownView(text: source.accessoryView.payload?.localized ?? "", drawsBackground: true)
        case .progressbar:
            try? ProgressBarView(viewModel: source.viewModel as? ProgressBarViewModel)
                .accessibilityIdentifier("progressbar_accessory_view")
        case .datepicker:
            try? DatePickerView(source.accessoryView.payload ?? "", output: source.$output, mainButtonState: source.$mainButtonState, secondaryButtonState: source.$secondaryButtonState)
                .accessibilityIdentifier("datepicker_accessory_view")
        default:
            EmptyView()
        }
    }
}

extension AccessoryViewWrapper: Equatable {
    static func == (lhs: AccessoryViewWrapper, rhs: AccessoryViewWrapper) -> Bool {
        return lhs.source == rhs.source
    }
}

extension AccessoryViewWrapper: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.source)
    }
}
