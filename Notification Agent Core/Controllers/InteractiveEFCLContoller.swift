//
//  InteractiveEFCLContoller.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/15/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This controller handle the background observation for interactive input from command line execution of the agent.
final class InteractiveEFCLController {
    
    // MARK: Variables
    var subtask: Process

    // MARK: - Initializers

    init(for subtask: Process) {
        self.subtask = subtask
    }

    // MARK: - Public methods

    /// Start the background observing for new inputs.
    func startObservingStandardInput() {
        func getInput() -> Data {
            let input = FileHandle.standardInput
            let inputData = input.availableData
            return inputData
        }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            while true {
                let input = getInput()
                if !input.isEmpty {
                    guard let strData = String(data: input, encoding: String.Encoding.utf8),
                          strData.trimmingCharacters(in: CharacterSet.newlines).lowercased() != "exit" else {
                        self?.subtask.interrupt()
                        exit(0)
                    }
                }
                (self?.subtask.standardInput as? Pipe)?.fileHandleForWriting.write(input)
            }
        }
    }
}
