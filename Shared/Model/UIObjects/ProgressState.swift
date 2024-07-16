//
//  ProgressState.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/15/20.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// This object describe a state for the progress bar view.
struct ProgressState: Equatable {
    /// The percentage of completition of the bar.
    var percent: Double
    /// The message on top of the bar.
    var topMessage: String
    /// The message on the bottom of the bar.
    var bottomMessage: String
    /// If the bar is an indeterminate loading.
    var isIndeterminate: Bool = false
    /// If the popop should allow user interaction during progressbar loading.
    var isUserInteractionEnabled = false
    /// If the popop should allow user interruption during progressbar loading.
    var isUserInterruptionAllowed = false
    /// If the popup should automatically close at the end of the progress.
    var exitOnCompletion: Bool = false
    
    init(_ payload: String? = nil, currentState: ProgressState? = nil) {
        self.percent = currentState?.percent ?? 0
        self.topMessage = currentState?.topMessage ?? ""
        self.bottomMessage =  currentState?.bottomMessage ?? ""
        self.isIndeterminate = currentState?.isIndeterminate ?? false
        self.isUserInteractionEnabled = currentState?.isUserInteractionEnabled ?? false
        self.isUserInterruptionAllowed = currentState?.isUserInterruptionAllowed ?? false
        self.exitOnCompletion = currentState?.exitOnCompletion ?? false
        guard let payload = payload else { return }
        guard payload.lowercased() != "end" else {
            self.percent = 100
            return
        }
        var splittedStrings = payload.split(separator: "/")
        splittedStrings.reverse()
        for index in 0..<splittedStrings.count {
            guard let argument = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first?.lowercased() else { continue }
            let value = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).last?.trimmingCharacters(in: CharacterSet.whitespaces)
            switch argument {
            case "percent":
                guard let value = value else { continue }
                guard let percentValue = Double(value == "indeterminate" ? "-1" : value) else { continue }
                self.percent = percentValue
            case "top_message":
                guard let value = value else { continue }
                self.topMessage = String(value != "top_message" ? value : "")
            case "bottom_message":
                guard let value = value else { continue }
                self.bottomMessage = String(value != "bottom_message" ? value : "")
            case "user_interaction_enabled":
                self.isUserInteractionEnabled = (value ?? "true").lowercased() == "true" ? true : false
            case "user_interruption_allowed":
                self.isUserInterruptionAllowed = (value ?? "true").lowercased() == "true" ? true : false
            case "exit_on_completion":
                self.exitOnCompletion = (value ?? "true").lowercased() == "true" ? true : false
            default:
                if index < splittedStrings.count-1 {
                    splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index])"))
                }
            }
        }
    }
}
