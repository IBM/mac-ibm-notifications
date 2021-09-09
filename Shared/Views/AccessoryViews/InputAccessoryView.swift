//
//  InputAccessoryView.swift
//  Notification Agent
//
//  Created by Jan Valentik on 03/11/2021.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view represents view with input box  and secured input box
class InputAccessoryView: AccessoryView {

    // MARK: - Private variables

    private var inputTextField: NSTextField
    private var fieldTopAnchor: NSLayoutConstraint!
    private var isRequired: Bool = false
    private var containerWidth: CGFloat {
        return self.superview?.bounds.width ?? 0
    }

    // MARK: - Variables

    var inputValue: String {
        return inputTextField.stringValue
    }
    var isSecure: Bool

    // MARK: - Initializers

    init(with payload: String? = nil, isSecure: Bool = false) throws {
        if isSecure {
            inputTextField = NSSecureTextField()
        } else {
            inputTextField = NSTextField()
        }
        self.isSecure = isSecure
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        self.addSubview(inputTextField)
        fieldTopAnchor = inputTextField.topAnchor.constraint(equalTo: self.topAnchor)
        fieldTopAnchor.isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        inputTextField.delegate = self
        try configureView(with: payload)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Instance methods
        
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        adjustViewSize()
        configureAccessibilityElements()
    }
    
    // MARK: - Private methods
    
    private func configureView(with payload: String?) throws {
        guard let payload = payload else { return }
        guard payload.contains("/placeholder") || payload.contains("/required") || payload.contains("/title") else {
            self.inputTextField.placeholderString = payload
            NALogger.shared.deprecationLog(since: AppVersion(major: 2, release: 6, fix: 0), deprecatedArgument: "input/secured input accessory view payload")
            return
        }
        var splittedStrings = payload.split(separator: "/")
        guard splittedStrings.count > 0 else {
            throw NAError.efclController(type: .invalidAccessoryViewPayload)
        }
        splittedStrings.reverse()
        for index in 0..<splittedStrings.count {
            guard let argument = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first?.lowercased() else { continue }
            let value = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).last?.trimmingCharacters(in: CharacterSet.whitespaces)
            switch argument {
            case "title":
                guard let value = value else { continue }
                let title = NSTextField(wrappingLabelWithString: value)
                title.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(title)
                title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                title.setAccessibilityLabel("accessory_view_accessibility_input_title".localized)
                fieldTopAnchor.isActive = false
                fieldTopAnchor = inputTextField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4)
                fieldTopAnchor.isActive = true
            case "placeholder":
                self.inputTextField.placeholderString = value
            case "required":
                self.isRequired = true
            default:
                if index < splittedStrings.count-1 {
                    splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index])"))
                }
            }
        }
        self.mainButtonState = self.isRequired ? .disabled : .enabled
    }
    
    private func adjustViewSize() {
        inputTextField.widthAnchor.constraint(equalToConstant: containerWidth).isActive = true
    }
    
    private func configureAccessibilityElements() {
        let accessibilityLabel = isSecure ?
            isRequired ? "accessory_view_accessibility_input_secured_required".localized : "accessory_view_accessibility_input_secured".localized :
            isRequired ? "accessory_view_accessibility_input_required".localized : "accessory_view_accessibility_input".localized
        inputTextField.setAccessibilityLabel("\(inputTextField.placeholderString ?? ""). \(accessibilityLabel)")
    }
}

extension InputAccessoryView: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        self.mainButtonState = inputTextField.stringValue.isEmpty ? .disabled : .enabled
        delegate?.accessoryViewStatusDidChange(self)
    }
}
