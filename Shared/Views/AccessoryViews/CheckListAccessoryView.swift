//
//  CheckListAccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 30/04/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view represents a list of elements with checkboxes
final class CheckListAccessoryView: AccessoryView {
    
    // MARK: Variables
    
    private var scrollView: NSScrollView!
    private var _containerWidth: CGFloat?
    private var containerWidth: CGFloat {
        return _containerWidth ?? (self.superview?.bounds.width ?? 0)
    }
    private var scrollViewHeightAnchor: NSLayoutConstraint!
    private var stackViewHeightAnchor: NSLayoutConstraint!
    private var stackViewWidthAnchor: NSLayoutConstraint!
    private var maxViewHeight: CGFloat
    private var title: NSTextField?
    
    var listStackView: FlippedStackView
    var elements: [NSButton] = []
    var isRequired: Bool = false
    var needCompletion: Bool = false
    var useRadioButtons: Bool = false
    var selectedIndexes: [Int] = []
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    init(with payload: String, maxViewHeight: CGFloat = 300, containerWidth: CGFloat? = nil) throws {
        self.maxViewHeight = maxViewHeight
        self.listStackView = FlippedStackView()
        self._containerWidth = containerWidth
        super.init(frame: .zero)
        try configureView(with: payload)
        self.identifier = NSUserInterfaceItemIdentifier("checklist_accessoryview")
    }
    
    // MARK: - Instance methods
    
    override func adjustViewSize() {
        let tempStackView = NSStackView()
        tempStackView.distribution = .fill
        tempStackView.orientation = .vertical
        tempStackView.alignment = .leading
        for element in elements {
            tempStackView.addArrangedSubview(element)
        }
        if let title = title {
            tempStackView.insertArrangedSubview(title, at: 0)
        }
        let stackViewHeight = tempStackView.fittingSize.height
        let scrollViewHeight = min(stackViewHeight, maxViewHeight)
        scrollViewHeightAnchor?.isActive = false
        scrollViewHeightAnchor = scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight)
        scrollViewHeightAnchor?.isActive = true
        stackViewWidthAnchor?.isActive = false
        stackViewWidthAnchor = listStackView.widthAnchor.constraint(equalToConstant: max(containerWidth-12, 0))
        stackViewWidthAnchor?.isActive = true
        stackViewHeightAnchor?.isActive = false
        stackViewHeightAnchor = listStackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        stackViewHeightAnchor?.isActive = true
        for element in elements {
            listStackView.addArrangedSubview(element)
        }
        if let title = title {
            listStackView.insertArrangedSubview(title, at: 0)
        }
    }
    
    override func configureAccessibilityElements() {
        self.setAccessibilityElement(false)
        title?.setAccessibilityLabel("accessory_view_accessibility_checklist_title".localized)
        title?.setAccessibilityIdentifier("accessory_view_accessibility_checklist_title")
        listStackView.setAccessibilityLabel("accessory_view_accessibility_checklist_liststackview".localized)
        listStackView.setAccessibilityIdentifier("accessory_view_accessibility_checklist_liststackview")
        scrollView.setAccessibilityLabel("accessory_view_accessibility_checklist_liststackview".localized)
        scrollView.setAccessibilityIdentifier("accessory_view_accessibility_checklist_liststackview")
    }
    
    override func displayStoredData(_ data: String) {
        let arrayOfStrings = data.split(separator: " ")
        var arrayOfIndexes: [Int] = []
        for string in arrayOfStrings {
            guard !string.isEmpty, let index = Int(string) else {
                continue
            }
            arrayOfIndexes.append(index)
        }
        for (index, element) in elements.enumerated() {
            if arrayOfIndexes.contains(index) {
                element.state = .on
                selectedIndexes.append(index)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func configureView(with payload: String) throws {
        self.elements = try parsePayload(payload)
        self.mainButtonState = !(self.isRequired || self.needCompletion || self.useRadioButtons) ? .enabled : .disabled
        listStackView.distribution = .fill
        listStackView.orientation = .vertical
        listStackView.translatesAutoresizingMaskIntoConstraints = false
        listStackView.alignment = .leading
        scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autohidesScrollers = true
        scrollView.verticalScroller = NoBackgroundScroller()
        scrollView.hasVerticalScroller = true
        scrollView.verticalScrollElasticity = .none
        scrollView.documentView = listStackView
        scrollView.drawsBackground = false
        self.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func parsePayload(_ payload: String) throws -> [NSButton] {
        var buttons: [NSButton] = []
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
                title = NSTextField(wrappingLabelWithString: value)
            case "list":
                guard let value = value else {
                    throw NAError.efclController(type: .invalidAccessoryViewPayload)
                }
                for line in value.description.lines {
                    let button = NSButton(checkboxWithTitle: line, target: self, action: #selector(didChangeCheckBoxSelection(_:)))
                    button.setAccessibilityLabel("accessory_view_accessibility_checklist_liststackview_element".localized)
                    buttons.append(button)
                }
            case "required":
                self.isRequired = true
            case "complete":
                self.needCompletion = true
            case "radio":
                self.useRadioButtons = true
            default:
                if index < splittedStrings.count-1 {
                    splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index])"))
                }
            }
        }
        if useRadioButtons {
            let radioButtons = buttons.map({ checkboxButton -> NSButton in
                let radioButton = NSButton(radioButtonWithTitle: checkboxButton.title, target: self, action: #selector(didChangeCheckBoxSelection(_:)))
                radioButton.setAccessibilityLabel("accessory_view_accessibility_checklist_liststackview_element".localized)
                return radioButton
            })
            return radioButtons
        }
        return buttons
    }
    
    // MARK: - Actions
    
    @objc
    private func didChangeCheckBoxSelection(_ sender: NSButton) {
        defer {
            delegate?.accessoryViewStatusDidChange(self)
        }
        if needCompletion {
            var flag: Bool = true
            selectedIndexes = []
            for index in elements.indices {
                guard elements[index].state == .on else {
                    flag = false
                    continue
                }
                selectedIndexes.append(index)
            }
            mainButtonState = flag ? .enabled : .disabled
        } else if isRequired || useRadioButtons {
            var flag: Bool = false
            selectedIndexes = []
            for index in elements.indices {
                guard elements[index].state == .on else {
                    continue
                }
                flag = true
                selectedIndexes.append(index)
            }
            mainButtonState = flag ? .enabled : .disabled
        } else {
            selectedIndexes = []
            for index in elements.indices {
                guard elements[index].state == .on else {
                    continue
                }
                selectedIndexes.append(index)
            }
        }
    }
}
