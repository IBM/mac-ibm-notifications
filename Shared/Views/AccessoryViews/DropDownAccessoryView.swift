//
//  DropDownAccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 14/04/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view represents a drop down combo box
class DropDownAccessoryView: AccessoryView {
    
    // MARK: - Private variables
    
    private var dropDown: NSComboBox
    private var defaultIndex: Int?
    private var containerWidth: CGFloat {
        return self.superview?.bounds.width ?? 0
    }
    private var dropDownTopAnchor: NSLayoutConstraint!
    
    // MARK: - Variables

    var selectedItem: Int {
        return dropDown.indexOfSelectedItem
    }
    
    // MARK: - Initializers
    
    init(with payload: String) throws {
        dropDown = NSComboBox()
        dropDown.isSelectable = false
        super.init(frame: .zero)
        dropDown.delegate = self
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dropDown)
        dropDownTopAnchor = dropDown.topAnchor.constraint(equalTo: self.topAnchor)
        dropDownTopAnchor.isActive = true
        dropDown.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropDown.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dropDown.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        try configureDropDown(with: payload)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        adjustViewSize()
        configureAccessibilityElements()
    }
    
    // MARK: - Private methods
    
    private func configureDropDown(with payload: String) throws {
        var splittedStrings = payload.split(separator: "/")
        guard splittedStrings.count > 0 else {
            throw NAError.efclController(type: .invalidAccessoryViewPayload)
        }
        splittedStrings.reverse()
        for index in 0..<splittedStrings.count {
            guard let argument = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first?.lowercased(),
                  let value = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).last?.trimmingCharacters(in: CharacterSet.whitespaces) else { continue }
            switch argument {
            case "title":
                let title = NSTextField(wrappingLabelWithString: value)
                title.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(title)
                title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                title.setAccessibilityLabel("accessory_view_accessibility_dropdown_title".localized)
                dropDownTopAnchor.isActive = false
                dropDownTopAnchor = dropDown.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4)
                dropDownTopAnchor.isActive = true
            case "placeholder":
                self.dropDown.placeholderString = value
            case "list":
                self.dropDown.removeAllItems()
                self.dropDown.addItems(withObjectValues: value.description.lines)
            case "selected":
                self.defaultIndex = Int(value)
            default:
                if index < splittedStrings.count-1 {
                    splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index])"))
                }
            }
        }
        if let index = defaultIndex, index < dropDown.numberOfItems {
            self.dropDown.selectItem(at: index)
        }
        self.mainButtonState = self.selectedItem >= 0 ? .enabled : .disabled
    }
    
    /// Adjust the view size based on the superview width and on the video height.
    private func adjustViewSize() {
        self.widthAnchor.constraint(equalToConstant: containerWidth).isActive = true
    }
    
    private func configureAccessibilityElements() {
        dropDown.setAccessibilityLabel("\(dropDown.placeholderString ?? ""). \("accessory_view_accessibility_dropdown".localized)")
    }
}

// MARK: - NSComboBoxDelegate methods implementation.
extension DropDownAccessoryView: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        defer {
            delegate?.accessoryViewStatusDidChange(self)
        }
        guard self.dropDown.indexOfSelectedItem >= 0 else { return }
        mainButtonState = .enabled
        secondaryButtonState = .enabled
    }
}
