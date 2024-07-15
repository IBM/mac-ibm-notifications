//
//  StandardButton.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/11/22.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// StandardButton struct define a view with a standard SwiftUI button that accept keyboard key equivalent.
struct StandardButton: View {
    
    // MARK: - Variables
    
    var keyboardShortcut: NativeButton.KeyEquivalent?
    
    // MARK: - Constants
    
    let action: () -> Void

    // MARK: - State Variables
    
    var label: String
    
    // MARK: - Binded Variables
    
    @Binding var buttonState: SwiftUIButtonState

    // MARK: - Views
    
    var body: some View {
        switch buttonState {
        case .enabled:
            if let key = keyboardShortcut {
                NativeButton(label, keyEquivalent: key) {
                    action()
                }
            } else {
                Button {
                    action()
                } label: {
                    Text(label)
                    .frame(minWidth: 44)
                }
            }
        case .disabled:
            if let key = keyboardShortcut {
                NativeButton(label, keyEquivalent: key) {
                    return
                }
                .disabled(true)
            } else {
                Button {
                    return
                } label: {
                    Text(label)
                    .frame(minWidth: 44)
                }
                .disabled(true)
            }
        case .hidden:
            Button {
                return
            } label: {
                Text(label)
                .frame(minWidth: 44)
            }
            .hidden()
        case .cancel:
            if let key = keyboardShortcut {
                NativeButton("cancel_label".localized, keyEquivalent: key) {
                    action()
                }
            } else {
                Button {
                    action()
                } label: {
                    Text("cancel_label".localized)
                    .frame(minWidth: 44)
                }
            }
        }
    }
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(keyboardShortcut: .return, action: {
            return
        }, label: "Main", buttonState: Binding(get: {
            return .enabled
        }, set: { _, _ in }))
    }
}
