//
//  InteractiveEFCLContoller.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/15/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// InteractiveEFCLController delegate
protocol InteractiveEFCLControllerDelegate: class {
    /// Triggered when a new state for the progress bar is available.
    /// - Parameter newState: The new state to be showed.
    func didReceivedNewStateforProgressBar(_ newState: ProgressState)
    /// Triggered when interactive updates ended.
    func didFinishedInteractiveUpdates()
}

/// This controller handle the background observation for interactive input from command line execution of the agent.
final class InteractiveEFCLController {

    // MARK: - Public variables

    weak var delegate: InteractiveEFCLControllerDelegate?

    // MARK: - Private variables

    private var shouldQuitObserving: Bool

    // MARK: - Initializers

    init() {
        shouldQuitObserving = false
    }

    // MARK: - Public methods

    /// Start the background observing for new states.
    /// - Parameter currentState: the current state.
    func startObservingForProgressBarUpdates(_ currentState: ProgressState) {
        func getInput() -> String {
            let input = FileHandle.standardInput
            let inputData = input.availableData
            let strData = String(data: inputData, encoding: String.Encoding.utf8)!
            let inputLine = strData.trimmingCharacters(in: CharacterSet.newlines)
            return inputLine
        }
        var currentState = currentState
        DispatchQueue.global(qos: .userInteractive).async {
            while !self.shouldQuitObserving {
                let input = getInput()
                guard input != "end" else {
                    self.shouldQuitObserving = true
                    self.delegate?.didFinishedInteractiveUpdates()
                    return
                }
                let newState = ProgressState(input, currentState: currentState)
                guard newState != currentState else { continue }
                self.delegate?.didReceivedNewStateforProgressBar(newState)
                currentState = newState
            }
        }
    }

    /// Stop the background observing for new states.
    func stopObservingForProgressBarUpdates() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.shouldQuitObserving = true
        }
    }
}
