//
//  InputView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/01/23.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import Combine

/// InputView is a struct that defines a view to display an input - secure or not - text field.
struct InputView: View {

    // MARK: - Support Enums
    
    enum InputCodingKeys: String, AVCIterable {
        case title
        case placeholder
        case value
        case required
    }
    
    // MARK: - Variables
    
    var title: String
    var placeholder: String
    var required: Bool
    var sub: AnyCancellable?
    var initialValue: String
    var subscribers: [AnyCancellable] = []
    
    // MARK: - Binded Variables
    
    // A binding to a String that is used to keep track of the accessory view output.
    @Binding var output: String
    // A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    @Binding var mainButtonState: SwiftUIButtonState
    // A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    @Binding var secondaryButtonState: SwiftUIButtonState

    // MARK: - State Variables
    
    @State var isSecure: Bool
    @State var inputValue: String
    
    // MARK: - Initializers

    init(_ payload: String,
         output: Binding<String>,
         mainButtonState: Binding<SwiftUIButtonState>,
         secondaryButtonState: Binding<SwiftUIButtonState>,
         legacyType: NotificationAccessoryElement.ViewType) throws {
        
        /// Initialize the binded variables
        _output = output
        _mainButtonState = mainButtonState
        _secondaryButtonState = secondaryButtonState
        
        /// Determine if the input field must be secure or not.
        isSecure = legacyType == .secureinput || legacyType == .securedinput
        
        /// Decode the payload using ACVDecoder.
        let decoder = ACVDecoder(codingKeys: InputCodingKeys.self)
        title = try decoder.decode(key: InputCodingKeys.title, ofType: String.self, from: payload)
        placeholder = try decoder.decode(key: InputCodingKeys.placeholder, ofType: String.self, from: payload)
        let somevalue = try decoder.decode(key: InputCodingKeys.value, ofType: String.self, from: payload)
        initialValue = !output.wrappedValue.isEmpty ? output.wrappedValue : somevalue
        inputValue = initialValue
        required = try decoder.decode(key: InputCodingKeys.required, ofType: Bool.self, from: payload)
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .fixedSize()
                    .accessibilityIdentifier("input_accessory_view_title")
            }
            /// Shows a standard TextField or a SecureField based on the isSecure value.
            if !isSecure {
                TextField(placeholder, text: $inputValue.onUpdate(updateReceived))
                    .accessibilityIdentifier("input_accessory_view_textfield")
            } else {
                SecureField(placeholder, text: $inputValue.onUpdate(updateReceived))
                    .accessibilityIdentifier("input_accessory_view_secure_textfield")
            }
        }
        .onAppear {
            updateReceived()
        }
    }
    
    // MARK: - Private Methods
    
    /// Evaluate the new state for the mainButtonState.
    private func updateReceived() {
        self.$output.wrappedValue = inputValue
        self.$mainButtonState.wrappedValue = self.required ? (!self.output.trimmingCharacters(in: .whitespaces).isEmpty ? .enabled : .disabled) : .enabled
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        try? InputView("/title This is a title /placeholder Some Placeholder /value Some", output: Binding(get: {
            return ""
        }, set: { _, _ in
            
        }), mainButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), secondaryButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), legacyType: .input)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
