//
//  NativeButton.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 21/11/22.
//  Copyright © 2022 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//  Credits: Sindre Sorhus (sindresorhus)
//

import SwiftUI

/// NativeButton struct define an NSViewRepresentable view that wrap a standard NSButton.
struct NativeButton: NSViewRepresentable {
    
    // MARK: - Support enums
    
    /// this enum map all the currently tracked keyboard keys.
    enum KeyEquivalent: String {
        case escape = "\u{1b}"
        case `return` = "\r"
    }

    // MARK: - Variables
    
    /// The button's title.
    var title: String?
    /// The title with attributed format.
    var attributedTitle: NSAttributedString?
    /// The key equivalent for this button.
    var keyEquivalent: KeyEquivalent?
    
    // MARK: - Constants
    
    /// This constant define the action tu run when the key pressure is recognized.
    let action: () -> Void

    // MARK: - Initializers
    
    init(_ title: String,
         keyEquivalent: KeyEquivalent? = nil,
         action: @escaping () -> Void) {
        self.title = title
        self.keyEquivalent = keyEquivalent
        self.action = action
    }
    
    init(_ attributedTitle: NSAttributedString,
         keyEquivalent: KeyEquivalent? = nil,
         action: @escaping () -> Void) {
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    // MARK: - NSViewRepresentable protocol methods
    
    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        return button
    }
    
    func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        if attributedTitle == nil {
            nsView.title = title ?? ""
        }
        if title == nil {
            nsView.attributedTitle = attributedTitle ?? NSAttributedString(string: "")
        }
        nsView.keyEquivalent = keyEquivalent?.rawValue ?? ""
        nsView.onAction { _ in
            self.action()
        }
    }
}
