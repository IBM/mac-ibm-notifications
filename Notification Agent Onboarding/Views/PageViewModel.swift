//
//  PageViewModel.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 26/04/2023.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import SwiftUI

/// PageViewModel class provides a view model for the PageView view.
final class PageViewModel: ObservableObject {
    
    // MARK: - Variables
    
    var page: InteractiveOnboardingPage
    var primaryButtonStates: [[SwiftUIButtonState]]
    var secondaryButtonStates: [[SwiftUIButtonState]]
    var accessoryViewsMatrix: [[AccessoryViewWrapper]]
    var viewSpec: ViewSpec
    
    // MARK: - Binded Variables
    
    @Binding var inputs: [[String]]
    @Binding var outputs: [[String]]
    @Binding var primaryButtonState: SwiftUIButtonState
    @Binding var secondaryButtonState: SwiftUIButtonState
    
    // MARK: - Initiliaziers
    
    init(page: InteractiveOnboardingPage,
         inp: Binding<[[String]]>,
         outp: Binding<[[String]]>,
         primaryButtonState: Binding<SwiftUIButtonState>,
         secondaryButtonState: Binding<SwiftUIButtonState>) {
        self.page = page
        self._inputs = inp
        self._outputs = outp
        self._primaryButtonState = primaryButtonState
        self._secondaryButtonState = secondaryButtonState
        self.viewSpec = ViewSpec(mainViewWidth: 832, contentMode: .fit, iconSize: CGSize(width: 86, height: 86))
        
        primaryButtonStates = []
        secondaryButtonStates = []
        accessoryViewsMatrix = []
        
        guard let accessoryViews = page.accessoryViews else { return }
        for (row, accessoryViewsRow) in accessoryViews.enumerated() {
            var primaryButtonStatesRow: [SwiftUIButtonState] = []
            var secondaryButtonStatesRow: [SwiftUIButtonState] = []
            var wrappedAccessoryViewsRow: [AccessoryViewWrapper] = []
            for (column, accessoryView) in accessoryViewsRow.enumerated() {
                var primaryButtonState: SwiftUIButtonState = .enabled
                primaryButtonStatesRow.append(primaryButtonState)
                var secondaryButtonState: SwiftUIButtonState = .enabled
                secondaryButtonStatesRow.append(secondaryButtonState)
                wrappedAccessoryViewsRow.append(AccessoryViewWrapper(source: AccessoryViewSource(output: Binding(get: {
                    return self.$outputs[row][column].wrappedValue
                }, set: { newValue, _ in
                    guard newValue != self.$outputs[row][column].wrappedValue else { return }
                    self.$outputs[row][column].wrappedValue = newValue
                    self.evaluateBindings()
                }), mainButtonState: Binding(get: {
                    return primaryButtonState
                }, set: { newValue, _ in
                    guard newValue != primaryButtonState else { return }
                    primaryButtonState = newValue
                    self.evaluateBindings()
                }), secondaryButtonState: Binding(get: {
                    return secondaryButtonState
                }, set: { newValue, _ in
                    guard newValue != secondaryButtonState else { return }
                    secondaryButtonState = newValue
                    self.evaluateBindings()
                }), accessoryView: accessoryView)))
            }
            primaryButtonStates.append(primaryButtonStatesRow)
            secondaryButtonStates.append(secondaryButtonStatesRow)
            accessoryViewsMatrix.append(wrappedAccessoryViewsRow)
        }
    }
    
    // MARK: - Public Methods
    
    /// Evaluate the current state of the binded variables.
    func evaluateBindings() {
        var localPrimaryButtonState: SwiftUIButtonState = .enabled
        var localSecondaryButtonState: SwiftUIButtonState = .enabled
        for row in accessoryViewsMatrix {
            for acv in row {
                switch acv.source.mainButtonState {
                case .enabled:
                    break
                case .disabled:
                    localPrimaryButtonState = .disabled
                case .hidden:
                    localPrimaryButtonState = .hidden
                case .cancel:
                    break
                }
                switch acv.source.secondaryButtonState {
                case .enabled:
                    break
                case .disabled:
                    localSecondaryButtonState = .disabled
                case .hidden:
                    localSecondaryButtonState = .hidden
                case .cancel:
                    break
                }
            }
        }
        if self.primaryButtonState != localPrimaryButtonState {
            self.primaryButtonState = localPrimaryButtonState
        }
        if self.secondaryButtonState != localSecondaryButtonState {
            self.secondaryButtonState = localSecondaryButtonState
        }
    }
}
