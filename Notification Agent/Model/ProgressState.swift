//
//  ProgressState.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/15/20.
//  Copyright © 2020 IBM Inc. All rights reserved
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

    init(_ payload: String? = nil, currentState: ProgressState? = nil) {
        self.percent = currentState?.percent ?? 0
        self.topMessage = currentState?.topMessage ?? ""
        self.bottomMessage =  currentState?.bottomMessage ?? ""
        self.isIndeterminate = currentState?.isIndeterminate ?? false
        guard let payload = payload else { return }
        let splittedStrings = payload.split(separator: "/")
        for string in splittedStrings {
            guard let argument = string.split(separator: " ", maxSplits: 1).first,
                  var value = string.split(separator: " ", maxSplits: 1).last else { continue }
            if value.last == " " {
                value.removeLast()
            }
            switch argument {
            case "percent":
                guard value != "indeterminate" else {
                    self.isIndeterminate = true
                    continue
                }
                guard let percentValue = Double(value) else { continue }
                self.isIndeterminate = false
                self.percent = percentValue
            case "top_message":
                self.topMessage = String(value != "top_message" ? value : "")
            case "bottom_message":
                self.bottomMessage = String(value != "bottom_message" ? value : "")
            case "user_interaction_enabled":
                self.isUserInteractionEnabled = value == "True" ? true : false
            case "user_interruption_allowed":
                self.isUserInterruptionAllowed = value == "True" ? true : false
            default:
                continue
            }
        }
    }
}
