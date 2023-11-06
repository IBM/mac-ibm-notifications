//
//  ChecklistView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 24/11/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import Combine

/// PickerView is a struct that defines a view for different kind of pickers.
struct PickerView: View {
    
    // MARK: - Support Enums
    
    /// This enum lists the different types of pickers available
    enum PickerType {
        case radiobuttons
        case checkboxlist
        case dropdown
    }

    // This enum lists the different coding keys for the checkbox list picker
    enum CheckListCodingKeys: String, AVCIterable {
        case title
        case list
        case needCompletion = "complete"
        case useRadioButtons = "radio"
        case preselection
        case required
    }

    /// This enum lists the different coding keys for the dropdown picker
    enum DropdownCodingKeys: String, AVCIterable {
        case title
        case list
        case placeholder
        case selected
    }

    // MARK: - Private Variables
    
    /// Properties to keep track of the title, placeholder, completion status, etc.
    private var title: String
    private var placeholder: String
    private var needCompletion: Bool
    private var useRadioButtons: Bool
    private var required: Bool
    private var type: PickerType
    private var initialValues: String
    
    // MARK: - Binded Variables
    
    /// A binding to a String that is used to keep track of the accessory view output.
    @Binding var output: String
    /// A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    @Binding var mainButtonState: SwiftUIButtonState
    /// A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    @Binding var secondaryButtonState: SwiftUIButtonState
    
    // MARK: - State Variables
    
    /// State variable to keep track of the picker items
    @State var values: [PickerItem]
    @State var selectionValue: String
    
    // MARK: - Initializers
    
    init(_ payload: String,
         output: Binding<String>,
         mainButtonState: Binding<SwiftUIButtonState>,
         secondaryButtonState: Binding<SwiftUIButtonState>,
         legacyType: NotificationAccessoryElement.ViewType) throws {
        
        /// Initialize the binded variables.
        _output = output
        _mainButtonState = mainButtonState
        _secondaryButtonState = secondaryButtonState

        /// Initialize an empty PickerItem support array.
        var someArray: [PickerItem] = []
        
        /// Determine the type of picker to be displayed and decode the payload accordingly using ACVDecoder.
        switch legacyType {
        case .dropdown:
            let decoder = ACVDecoder(codingKeys: DropdownCodingKeys.self)
            title = try decoder.decode(key: DropdownCodingKeys.title, ofType: String.self, from: payload)
            placeholder = try decoder.decode(key: DropdownCodingKeys.placeholder, ofType: String.self, from: payload)
            someArray = try decoder.decode(key: DropdownCodingKeys.list, ofType: [PickerItem].self, from: payload)
            required = !(try decoder.decode(key: DropdownCodingKeys.selected, ofType: String.self, from: payload) as String).isEmpty
            needCompletion = false
            useRadioButtons = false
            let somevalues = try decoder.decode(key: DropdownCodingKeys.selected, ofType: String.self, from: payload)
            initialValues = !output.wrappedValue.isEmpty && output.wrappedValue != "-1" ? output.wrappedValue  : (!somevalues.isEmpty ? somevalues : "-1")
            selectionValue = initialValues
            type = .dropdown
            values = someArray
        case .checklist:
            let decoder = ACVDecoder(codingKeys: CheckListCodingKeys.self)
            title = try decoder.decode(key: CheckListCodingKeys.title, ofType: String.self, from: payload)
            placeholder = ""
            someArray = try decoder.decode(key: CheckListCodingKeys.list, ofType: [PickerItem].self, from: payload)
            required = try decoder.decode(key: CheckListCodingKeys.required, ofType: Bool.self, from: payload)
            needCompletion = try decoder.decode(key: CheckListCodingKeys.needCompletion, ofType: Bool.self, from: payload)
            useRadioButtons = try decoder.decode(key: CheckListCodingKeys.useRadioButtons, ofType: Bool.self, from: payload)
            let somevalues = try decoder.decode(key: CheckListCodingKeys.preselection, ofType: String.self, from: payload)
            initialValues = !output.wrappedValue.isEmpty ? output.wrappedValue : somevalues
            selectionValue = initialValues
            type = useRadioButtons ? .radiobuttons : .checkboxlist
            values = someArray
        default:
            throw NAError.efclController(type: .invalidAccessoryViewPayload)
        }
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .fixedSize()
                    .accessibilityIdentifier("picker_accessory_view_title")
            }
            switch self.type {
            case .radiobuttons:
                Picker("", selection: self.$selectionValue.onUpdate(evaluateButtonState)) {
                    ForEach(self.$values) { element in
                        Text(element.label.wrappedValue).tag(element.id.wrappedValue.description).fixedSize(horizontal: false, vertical: true)
                    }
                }
                .pickerStyle(.radioGroup)
                .labelsHidden()
                .onAppear {
                    evaluateButtonState()
                }
                .accessibilityIdentifier("picker_accessory_view_radio_buttons")
            case .checkboxlist:
                VStack(alignment: .leading) {
                    ForEach(self.$values.onUpdate(evaluateButtonState)) { element in
                        Toggle(isOn: element.isSelected) {
                            Text(element.label.wrappedValue).tag(element.id.wrappedValue.description).fixedSize(horizontal: false, vertical: true)
                        }
                        .toggleStyle(.checkbox)
                        .accessibilityIdentifier("picker_accessory_view_checkboxes_\(element.label.wrappedValue.trimmingCharacters(in: .whitespaces))")
                    }
                }
                .onAppear {
                    if !initialValues.isEmpty {
                        let selectedIndexes = initialValues.split(separator: " ")
                        selectedIndexes.forEach { indexString in
                            guard let index = Int(indexString), index < values.count else { return }
                            values[index].isSelected = true
                        }
                    }
                    evaluateButtonState()
                }
            case .dropdown:
                Picker("", selection: self.$selectionValue.onUpdate(evaluateButtonState)) {
                    Text(placeholder).tag("-1")
                    ForEach(self.$values) { element in
                        Text(element.label.wrappedValue).tag(element.id.wrappedValue.description)
                    }
                }
                .labelsHidden()
                .onAppear {
                    evaluateButtonState()
                }
                .accessibilityIdentifier("picker_accessory_view_dropdown")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func evaluateButtonState() {
        switch type {
        case .dropdown:
            $output.wrappedValue = selectionValue != "-1" ? selectionValue : ""
            $mainButtonState.wrappedValue = output.isEmpty || output == "-1" ? .disabled : .enabled
        case .checkboxlist:
            var selectedIndexes: String = ""
            for (index, item) in self.values.enumerated() where item.isSelected {
                selectedIndexes.append("\(index) ")
            }
            if !selectedIndexes.isEmpty {
                _ = selectedIndexes.removeLast()
            }
            $output.wrappedValue = selectedIndexes
            if needCompletion {
                $mainButtonState.wrappedValue = output.split(separator: " ").count == values.count ? .enabled : .disabled
            } else {
                $mainButtonState.wrappedValue = output.isEmpty && required ? .disabled : .enabled
            }
        case .radiobuttons:
            $output.wrappedValue = selectionValue != "-1" ? selectionValue : "" 
            $mainButtonState.wrappedValue = output.isEmpty && required ? .disabled : .enabled
        }
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        try? PickerView("/title This is a title /list one\ntwo\nthree /radio /preselection 1", output: Binding(get: {
            return ""
        }, set: { _, _ in
            
        }), mainButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), secondaryButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), legacyType: .checklist)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
