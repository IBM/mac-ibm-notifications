//
//  CircleButton.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/11/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// CircleButton is a struct that defines a view with a circle shaped button.
struct CircleButton: View {
    
    // MARK: - Support Enum
    
    enum CircleButtonType {
        case help
        case warning
        
        /// Returns the label to display in the button
        var label: some View {
            switch self {
            case .help:
                return AnyView(Image(systemName: "questionmark"))
            case .warning:
                return AnyView(Image(systemName: "exclamationmark"))
            }
        }
    }
    
    // MARK: - Variables
    
    let action: () -> Void
    let popoverText: String?
    let infoSection: InfoSection?
    let type: CircleButtonType
    
    // MARK: - State Variables
    
    @Binding var buttonState: SwiftUIButtonState
    @Binding var showPopover: Bool
    
    // MARK: - Initializers
    
    init(action: @escaping () -> Void, popoverText: String? = nil, infoSection: InfoSection? = nil, type: CircleButtonType, buttonState: Binding<SwiftUIButtonState>, showPopover: Binding<Bool>) {
        self.action = action
        self.popoverText = popoverText
        self.infoSection = infoSection
        self.type = type
        self._buttonState = buttonState
        self._showPopover = showPopover
    }
    
    // MARK: - Views
    
    var body: some View {
        buttonWithAppearance
            .popover(isPresented: $showPopover, arrowEdge: popoverText != nil ? .bottom : .trailing) {
                if let plainText = popoverText {
                    Text(plainText)
                        .padding()
                } else if let info = infoSection {
                    InfoSectionView(section: info)
                }
            }
    }
    
    var buttonWithAppearance: some View {
        switch buttonState {
        case .enabled:
            return AnyView(baseButton)
        case .disabled:
            return AnyView(baseButton.disabled(true))
        case .hidden:
            return AnyView(EmptyView())
        case .cancel:
            return AnyView(EmptyView()) /// A circle button should never have the cancel state.
        }
    }
    
    var baseButton: some View {
        Button {
            action()
        } label: {
            type.label
        }
        .clipShape(Circle())
    }
    
    func idealHeight(for infoSection: InfoSection) -> CGFloat {
        var height: CGFloat = 0
        
        for item in infoSection.fields {
            let itemLabelHeight = NSTextField(wrappingLabelWithString: item.label).sizeThatFits(NSSize(width: 150, height: 0)).height
            let itemDescriptionHeight = NSTextField(wrappingLabelWithString: item.description ?? "").sizeThatFits(NSSize(width: 450, height: 0)).height
            let itemHeight = max(itemLabelHeight, itemDescriptionHeight)
            height += itemHeight
        }
        
        return height
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(action: {
            return
        }, type: .help, buttonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), showPopover: Binding(get: {
            return true
        }, set: { _, _ in
            
        }))
    }
}
