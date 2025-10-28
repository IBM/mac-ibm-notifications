//
//  OnboardingInteractiveEFCLController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 24/06/22.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

final class OnboardingInteractiveEFCLController: InteractiveEFCLController {
    override func processInput(_ notification: Notification) {
        let inputData = inputPipe.availableData
        if !inputData.isEmpty {
            guard let strData = String(data: inputData, encoding: String.Encoding.utf8)?.trimmingCharacters(in: CharacterSet.newlines) else { return }
            let splittedStrings = strData.split(separator: "/")
            for string in splittedStrings {
                guard let argument = string.split(separator: " ", maxSplits: 1).first?.lowercased(),
                      var value = string.split(separator: " ", maxSplits: 1).last else { continue }
                if value.last == " " {
                    value.removeLast()
                }
                switch argument {
                case "percent", "top_message", "bottom_message", "user_interaction_enabled", "user_interruption_allowed", "exit_on_completion", "end":
                    NotificationCenter.default.post(name: Notification.Name("progressbar_interactive_updates"), object: nil, userInfo: ["data" : inputData])
                default:
                    continue
                }
            }
        }
        inputPipe.waitForDataInBackgroundAndNotify()
    }
}
