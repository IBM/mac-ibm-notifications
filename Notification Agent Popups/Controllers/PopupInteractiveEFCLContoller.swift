//
//  InteractiveEFCLContoller.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/15/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// InteractiveEFCLController delegate
protocol PopupInteractiveEFCLControllerDelegate: AnyObject {
    /// Triggered when a new state for the progress bar is available.
    /// - Parameter newState: The new state to be showed.
    func didReceivedNewStateforProgressBar(_ newState: ProgressState)
    /// Triggered when interactive updates ended.
    func didFinishedInteractiveUpdates()
}

/// This controller handle the background observation for interactive input from command line execution of the agent.
final class PopupInteractiveEFCLController: InteractiveEFCLController {

    // MARK: - Public variables
    
    weak var delegate: PopupInteractiveEFCLControllerDelegate?
    
    // MARK: - Private variables
    
    private var currentState: ProgressState!
    
    init(_ currentState: ProgressState) {
        self.currentState = currentState
        super.init()
    }
    
    // MARK: - Private methods
    
    /// Process the new data from the standard input
    override func processInput(_ notification: Notification) {
        let inputData = inputPipe.availableData
        if !inputData.isEmpty {
            guard let strData = String(data: inputData, encoding: String.Encoding.utf8),
                  strData.trimmingCharacters(in: CharacterSet.newlines).lowercased() != "end" else {
                      self.delegate?.didFinishedInteractiveUpdates()
                      return
                  }
            let newState = ProgressState(strData.trimmingCharacters(in: CharacterSet.newlines).lowercased(), currentState: currentState)
            guard newState != currentState else {
                inputPipe.waitForDataInBackgroundAndNotify()
                return
            }
            self.delegate?.didReceivedNewStateforProgressBar(newState)
            currentState = newState
        }
        inputPipe.waitForDataInBackgroundAndNotify()
    }
}
