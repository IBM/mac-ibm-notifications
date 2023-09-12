//
//  EFCLController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/26/20.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// ExecutionFromCommandLineController handle the launch of the agent from command line.
class EFCLController {
    
    // MARK: - Static Variables

    static let shared = EFCLController()
    static let specialArguments = ["-NSDocumentRevisionsDebugMode",
                                   "--isRunningTest",
                                   "--v",
                                   "--help",
                                   "--version",
                                   "--terms",
                                   "--privacy",
                                   "--isRunningTest",
                                   "--config",
                                   "--resetBanners",
                                   "--resetAlerts",
                                   "-reset",
                                   "sudo"]
    static let standaloneBooleanArguments = ["always_on_top",
                                             "silent",
                                             "miniaturizable",
                                             "force_light_mode",
                                             "hide_title_bar_buttons",
                                             "retain_values",
                                             "show_suppression_button",
                                             "unmovable",
                                             "disable_quit"]
    // MARK: - Variables

    let context = Context.main
    let logger = NALogger.shared
    var isRunningTestForEFCL: Bool {
        return CommandLine.arguments.contains("--isRunningTest")
    }
}
