//
//  InputAccessoryView.swift
//  Notification Agent
//
//  Created by Jan Valentik on 03/11/2020.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view represents view with input box  and secured input box
final class InputAccessoryView: NSView {

    // MARK: - Private variables

    private var inputTextField: NSTextField

    // MARK: - Variables

    var inputValue: String {
        return inputTextField.stringValue
    }

    // MARK: - Initializers

    init(with placeholder: String? = nil, isSecured: Bool = false) {
        if isSecured {
            inputTextField = NSSecureTextField()
        } else {
            inputTextField = NSTextField()
        }
        inputTextField.placeholderString = placeholder
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        self.addSubview(inputTextField)
        inputTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
