//
//  ProgressBarViewModel.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 20/03/23.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import SwiftUI

class ProgressBarViewModel: ObservableObject, AccessoryViewController, InteractiveObjectProtocol {
    
    // MARK: - Binded Viariables
    
    /// Published variable that represents the current state for the progress bar.
    @Published var progressState: ProgressState
    /// A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    @Binding var mainButtonState: SwiftUIButtonState
    /// A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    @Binding var secondaryButtonState: SwiftUIButtonState
    
    // MARK: Initializers
    
    init(progressState: ProgressState,
         mainButtonState: Binding<SwiftUIButtonState>,
         secondaryButtonState: Binding<SwiftUIButtonState>) {
        self.progressState = progressState
        self._mainButtonState = mainButtonState
        self._secondaryButtonState = secondaryButtonState
        self.startObservingForUpdates()
    }
    
    /// Define the main/secondary buttons state based on the new progress bar state.
    /// - Parameter progressState: new progress bar state
    func setButtonsState(for progressState: ProgressState) {
        if progressState.percent == 100 {
            mainButtonState = .enabled
            secondaryButtonState = .enabled
        } else {
            mainButtonState = progressState.isUserInteractionEnabled ? .enabled : progressState.isUserInterruptionAllowed ? .cancel : .hidden
            secondaryButtonState = progressState.isUserInteractionEnabled ? .enabled : .hidden
        }
    }
    
    // MARK: - InteractiveObjectProtocol protocol conformity - START
    
    var objectIdentifier: String = "progressbar_interactive_updates"
    
    func processInput(_ notification: Notification) {
        guard let inputData = notification.userInfo?["data"] as? Data else { return }
        if !inputData.isEmpty {
            guard let strData = String(data: inputData, encoding: String.Encoding.utf8) else { return }
            let newState = ProgressState(strData.trimmingCharacters(in: CharacterSet.newlines), currentState: progressState)
            guard newState != progressState else { return }
            DispatchQueue.main.async {
                self.progressState = newState
                if newState.percent == 100 && newState.exitOnCompletion {
                    Utils.applicationExit(withReason: .mainButtonClicked)
                    return
                }
                self.setButtonsState(for: newState)
            }
        }
    }
    
    // MARK: - InteractiveObjectProtocol protocol conformity - END
}

protocol AccessoryViewController {
    /// A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    var mainButtonState: SwiftUIButtonState { get set }
    /// A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    var secondaryButtonState: SwiftUIButtonState { get set }
}
