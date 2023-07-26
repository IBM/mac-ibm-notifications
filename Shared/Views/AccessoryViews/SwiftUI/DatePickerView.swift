//
//  DatePickerView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 24/05/2023.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import Combine

/// DatePickerView is a struct that define a view and logic to handle Date input.
struct DatePickerView: View {
    
    // MARK: - Support Enums
    
    /// This enum lists the different coding keys for the DatePicker
    enum DatePickerCodingKeys: String, AVCIterable {
        case title
        case preselection
        case components
        case style
    }
    
    // MARK: - Private Variables
    
    /// Properties to keep track of the title, placeholder, completion status, etc.
    private var title: String
    private var style: any DatePickerStyle
    private var components: DatePickerComponents
    private var initialDate: Date?
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }
    
    // MARK: - Binded Variables
    
    /// A binding to a String that is used to keep track of the accessory view output.
    @Binding var output: String
    /// A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    @Binding var mainButtonState: SwiftUIButtonState
    /// A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    @Binding var secondaryButtonState: SwiftUIButtonState
    
    // MARK: - State Variables
    
    @State var selectionValue: Date = Date()
    
    // MARK: - Initializers
    
    init(_ payload: String,
         output: Binding<String>,
         mainButtonState: Binding<SwiftUIButtonState>,
         secondaryButtonState: Binding<SwiftUIButtonState>) throws {
        
        /// Initialize the binded variables.
        _output = output
        _mainButtonState = mainButtonState
        _secondaryButtonState = secondaryButtonState
        
        let decoder = ACVDecoder(codingKeys: DatePickerCodingKeys.self)
        title = try decoder.decode(key: DatePickerCodingKeys.title, ofType: String.self, from: payload)
        let rawStyle = try decoder.decode(key: DatePickerCodingKeys.style, ofType: String.self, from: payload)
        switch rawStyle.lowercased() {
        case "graphical":
            style = GraphicalDatePickerStyle()
        case "field":
            style = FieldDatePickerStyle()
        case "compact":
            style = CompactDatePickerStyle()
        case "stepperfield":
            style = StepperFieldDatePickerStyle()
        default:
            style = DefaultDatePickerStyle()
        }
        let rawComponentsField = try decoder.decode(key: DatePickerCodingKeys.components, ofType: String.self, from: payload)
        switch rawComponentsField.lowercased() {
        case "date":
            components = [.date]
        case "time":
            components = [.hourAndMinute]
        default:
            components = [.date, .hourAndMinute]
        }
        let somevalues = try decoder.decode(key: DatePickerCodingKeys.preselection, ofType: String.self, from: payload)
        initialDate = dateFormatter.date(from: output.wrappedValue.isEmpty ? somevalues : output.wrappedValue) ?? Date()
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .fixedSize()
                    .accessibilityIdentifier("datepicker_accessory_view_title")
            }
            HStack(spacing: 0) {
                DatePicker("", selection: $selectionValue.onUpdate(evaluateButtonState), displayedComponents: components)
                    .customDatePickerStyle(style)
                    .labelsHidden()
                    .onAppear {
                        if let initialDate = initialDate {
                            self.selectionValue = initialDate
                        }
                        evaluateButtonState()
                    }
                    .accessibilityIdentifier("datepicker_accessory_view_picker")
                Spacer()
            }
            .padding(0)
        }
    }
    
    // MARK: - Private Methods
    
    private func evaluateButtonState() {
        $output.wrappedValue = dateFormatter.string(from: selectionValue)
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        try? DatePickerView("/title This is a title", output: Binding(get: {
            return ""
        }, set: { _, _ in
            
        }), mainButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), secondaryButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}

/// Custom modifier to provide a generic way to define DatePicker style.
struct CustomDatePickerStyleModifier: ViewModifier {
    var style: any DatePickerStyle

    func body(content: Content) -> some View {
        switch style {
        case is FieldDatePickerStyle:
            content
                .datePickerStyle(.field)
        case is GraphicalDatePickerStyle:
            content
                .datePickerStyle(.graphical)
        case is CompactDatePickerStyle:
            content
                .datePickerStyle(.compact)
        case is StepperFieldDatePickerStyle:
            content
                .datePickerStyle(.stepperField)
        case is DefaultDatePickerStyle:
            content
                .datePickerStyle(.automatic)
        default:
            content
                .datePickerStyle(.automatic)
        }
    }
}

extension View {
    func customDatePickerStyle(_ style: any DatePickerStyle) -> some View {
        self.modifier(CustomDatePickerStyleModifier(style: style))
    }
}
