//
//  TaskManager.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 16/06/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import SystemConfiguration

final class TaskManager {
    var interactiveInputController: InteractiveEFCLController?
    var runningUITasks: Set<Process> = []
    
    func interruptUITasks() {
        runningUITasks.forEach({ $0.interrupt() })
    }

    func runSyncTaskOnComponent(_ component: AppComponent, with jsonObject: Data, isInteractive: Bool = false, completion: (Int32) -> Void) -> Int32 {
        let task = buildTask(for: component, with: jsonObject)
        if isInteractive {
            interactiveInputController = InteractiveEFCLController(for: task)
            interactiveInputController?.startObservingStandardInput()
        }
        task.launch()
        runningUITasks.insert(task)
        task.waitUntilExit()
        runningUITasks.remove(task)
        if let outputData = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData,
           let output = String(data: outputData, encoding: .utf8) {
            print(output)
        }
        if let errorData = (task.standardError as? Pipe)?.fileHandleForReading.availableData,
           let error = String(data: errorData, encoding: .utf8) {
            NALogger.shared.log("%{public}@", [error])
        }
        return task.terminationStatus
    }
    
    func runAsyncTaskOnComponent(_ component: AppComponent, with jsonObject: Data, isInteractive: Bool = false, completion: @escaping (Int32) -> Void) {
        let task = buildTask(for: component, with: jsonObject)
        if isInteractive {
            interactiveInputController = InteractiveEFCLController(for: task)
            interactiveInputController?.startObservingStandardInput()
        }
        task.launch()
        runningUITasks.insert(task)
        task.waitUntilExit()
        runningUITasks.remove(task)
        if let outputData = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData,
           let output = String(data: outputData, encoding: .utf8) {
            print(output)
        }
        if let errorData = (task.standardError as? Pipe)?.fileHandleForReading.availableData,
           let error = String(data: errorData, encoding: .utf8) {
            NALogger.shared.log("%{public}@", [error])
        }
        completion(task.terminationStatus)
    }
    
    func runUntrackedTaskOnComponent(_ component: AppComponent, with jsonObject: Data) {
        let task = buildTask(for: component, with: jsonObject)
        task.launch()
    }
    
    func buildTask(for component: AppComponent, with jsonObject: Data) -> Process {
        let task = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let inputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.standardInput = inputPipe
        if let loggedInUser = loggedUser() {
            let suArgsString = "'" + component.getRelativeComponentPath() + "'" + " " + jsonObject.base64EncodedString()
            var suArgsArray: [String] = [suArgsString]
            task.launchPath = "/usr/bin/su"
            suArgsArray.insert("-c", at: 0)
            suArgsArray.insert(loggedInUser, at: 0)
            suArgsArray.insert("-l", at: 0)
            task.arguments = suArgsArray
        } else {
            task.launchPath = component.getRelativeComponentPath()
            task.arguments = [jsonObject.base64EncodedString()]
        }
        return task
    }
    
    func loggedUser() -> String? {
        guard let loggedInUser = SCDynamicStoreCopyConsoleUser(nil, nil, nil) as String?,
              !loggedInUser.isEmpty && loggedInUser != "loginwindow" else { return nil }
        let userName = NSUserName()
        if userName != loggedInUser {
            return loggedInUser
        } else {
            return nil
        }
    }
}
