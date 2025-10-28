//
//  InteractiveEFCLContoller.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/15/20.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This controller handle the background observation for interactive input from command line execution of the agent.
open class InteractiveEFCLController {
    
    // MARK: Variables
    var subtask: Process!
    var inputPipe: FileHandle!
    
    // MARK: - Initializers
    
    init(for subtask: Process? = nil) {
        self.subtask = subtask
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSFileHandleDataAvailable, object: nil)
    }
    
    // MARK: - Public methods
    
    /// Start the background observing for new inputs.
    func startObservingStandardInput() {
        inputPipe = FileHandle.standardInput
        NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: nil, queue: .main, using: self.processInput(_:))
        inputPipe.waitForDataInBackgroundAndNotify()
    }
        
    /// Process the new data from the standard input
    func processInput(_ notification: Notification) {
        let inputData = inputPipe.availableData
        if !inputData.isEmpty {
            guard let strData = String(data: inputData, encoding: String.Encoding.utf8),
                  strData.trimmingCharacters(in: CharacterSet.newlines).lowercased() != "exit" else {
                      self.subtask.interrupt()
                      exit(0)
                  }
            (self.subtask.standardInput as? Pipe)?.fileHandleForWriting.write(inputData)
        }
        inputPipe.waitForDataInBackgroundAndNotify()
    }
}
