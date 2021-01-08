//
//  HelpBuilder.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/27/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable line_length

import Foundation

public final class HelpBuilder {
    static let arguments: [String] = ["-type".green(),
                                      "-bar_title".yellow(),
                                      "-title".yellow(),
                                      "-subtitle".yellow(),
                                      "-icon_path".yellow(),
                                      "-accessory_view_type".yellow(),
                                      "-accessory_view_payload".yellow(),
                                      "-main_button_label".yellow(),
                                      "-main_button_cta_type".yellow(),
                                      "-main_button_cta_payload".yellow(),
                                      "-secondary_button_label".yellow(),
                                      "-secondary_button_cta_type".yellow(),
                                      "-secondary_button_cta_payload".yellow(),
                                      "-tertiary_button_label".yellow(),
                                      "-tertiary_button_cta_type".yellow(),
                                      "-tertiary_button_cta_payload".yellow(),
                                      "-help_button_cta_type".yellow(),
                                      "-help_button_cta_payload".yellow(),
                                      "-timeout".yellow(),
                                      "-always_on_top".yellow()]
    static let descriptions: [String] = ["[ popup | banner ]".red() + "\n      The UI type of the notification.",
                                         "\n      The bar title for the \"popup\" UI type. Not used for \"banner\" UI type.",
                                         "\n      The title of the notification.",
                                         "\n      The subtitle of the notification.",
                                         "\n      The custom icon path defined for this notification (Available only for popup \"type\"",
                                         "[ text | whitebox | timer | image | video | progressbar | input | securedInput ]".red() + "\n      The UI type for the needed accessory view.",
                                         "\n      The payload for the accessory view:\n      - Text for " + "[ text | whitebox ]".red() + " view type;\n      - Seconds for " + "[ timer ]".red() + " view type;\n      - File path/link for " + "[ image | video ]".red() + " view type;\n      - Text with the format " + "\"/percent DOUBLE /top_message TEXT /bottom_message TEXT /user_interaction_enabled BOOL /user_interruption_allowed BOOL\" ".green() + "for " + "[ progressbar ]".red() + " view type;\n      - Text as placeholder for the " + "[ input | securedInput ]".red() + " view type.",
                                         "\n      The label of the main button",
                                         "[ none | link ]".red() + "\n      The call to action type for the main button (default: none -> exit).",
                                         "\n      An URL if " + "[ link ]".red() + " cta type defined.",
                                         "\n      The label of the secondary button.",
                                         "[ none | link ]".red() + "\n      The call to action type for the secondary button (default: none -> exit).",
                                         "\n      An URL if " + "[ link ]".red() + " cta type defined.",
                                         "\n      The label of the tertiary button.",
                                         "[ link | exitlink ]".red() + "\n      The call to action type for the tertiary button.",
                                         "\n      A mandatory URL if " + "[ link ]".red() + " cta type defined, optional if " + "[ exitlink ]".red() + " cta defined.",
                                         "[ link | infopopup ]".red() + "\n      The call to action type for the help button.",
                                         "\n      An URL for " + "[ link ]".red() + " cta type or text for " + "[ infopopup ]".red() + " cta type.",
                                         "\n      The timeout for the notification. After this amount of seconds the main action is triggered if no " + "[ timer ]".red() + " accessory view was defined. Available only for " + "[ popup ]".red() + " UI type.",
                                         "\n      Flag that tells the UI to keep the popup always on top of the window hierarchy."]
    static let syntacticRules: [String] = ["At least one argument between" + " [ -title | -subtitle | -accessory_view_type + -accessory_view_payload ] ".red() + "must be defined to present a popup/banner.",
                                           "By default tertiary button on " + "[ popup ]".red() + " UI type is not destructive. Use " + "[ exitlink ]".red() + " cta type to trigger a link (optional) and make it destructive for the popup.",
                                          "In general if a call to action type is defined for a button, must be defined also the related payload. Except for the cta types " + "[ none | exitlink ]".red() + "."]
    static let notes: [String] = ["If no call to action type defined for a button the default one is " + "[ none ]".red() + ", that simply return the exit code related to the clicked button.",
                                      "Help button will not be showed on " + "[ banner ]".red() + " UI type.",
                                      "Accessory views will not be showed on " + "[ banner ]".red() + " UI type."]
    static let specialArguments: [String] = ["--help".blue(),
                                             "--version".blue(),
                                             "--v".blue()]
    static let specialArgumentsDescriptions: [String] = ["Show help's page",
                                             "Show app's version",
                                             "Verbose mode"]
    static let configurableParameters: [String] = ["-default_popup_bar_title".yellow(),
                                                   "-default_popup_icon_path".yellow(),
                                                   "-default_popup_timeout".yellow(),
                                                   "-default_banner_timeout".yellow(),
                                                   "-default_main_button_label".yellow()]
    static let configurableParametersDescriptions: [String] = ["Default popups bar title.",
                                                               "Path for the default popups icon.",
                                                               "Default popups background timeout.",
                                                               "Default banners backgound timeout.",
                                                               "Default main button label."]
    static let returnValues: [String] = ["0".bold(),
                                         "1".bold(),
                                         "2".bold(),
                                         "3".bold(),
                                         "200".bold(),
                                         "201".bold(),
                                         "239".bold(),
                                         "250".bold(),
                                         "255".bold(),
                                         "260".bold()]
    static let returnValuesDescription: [String] = ["Main button clicked.",
                                                    "Internal error.",
                                                    "Secondary button clicked.",
                                                    "Tertiary button clicked.",
                                                    "Untracked success.",
                                                    "User dimissed the notification banner",
                                                    "Received SigInt.",
                                                    "Invalid number of arguments.",
                                                    "Invalid arguments syntax.",
                                                    "Unable to load resources"]
    static let examplePopup: String = "[~/Mac@IBM.app/Contents/MacOS/Mac@IBM -type popup -title \"Test title\" -subtitle \"Test subtitle\" -accessory_view_type whitebox -accessory_view_payload \"Test accessory view\" -main_button_label \"Main button\" -secondary_button_label \"Secondary button\" -tertiary_button_label \"Tertiary button\" -tertiary_button_cta_type link -tertiary_button_cta_payload \"https://www.google.com\" -help_button_cta_type infopopup -help_button_cta_payload \"Test help text\"]"
    static let exampleBanner: String = "[~/Mac@IBM.app/Contents/MacOS/Mac@IBM -type banner -title \"Test title\" -subtitle \"Test subtitle\" -accessory_view_type whitebox -accessory_view_payload \"Test accessory view\" -main_button_label \"Main button\" -secondary_button_label \"Secondary button\" -tertiary_button_label \"Tertiary button\" -tertiary_button_cta_type link -tertiary_button_cta_payload \"https://www.google.com\""

    static func printHelpPage() {
        print("\nMac@IBM Notification Agent Help Page".bold().blue() + "\n")
        var argumentsString = ""
        for argument in arguments {
            argumentsString += "[\(argument)] "
        }
        print("Usage: ".cyan().bold() + "\n~/Mac@IBM.app/Contents/MacOS/Mac@IBM " + argumentsString + "\n")
        print("Color Legend: ".cyan().bold())
        print("Mandatory value".green() + " " + "Optional value".yellow() + "\n")
        print("Arguments details:".cyan().bold())
        for index in arguments.indices {
            print("\(arguments[index]): \(descriptions[index])")
        }
        print("\nSyntactic rules:".bold().cyan())
        for index in syntacticRules.indices {
            print("- \(syntacticRules[index])")
        }
        print("\nBe aware of:".bold().cyan())
        for index in notes.indices {
            print("- \(notes[index])")
        }
        print("\nSpecial arguments:".bold().cyan())
        for index in specialArguments.indices {
            print("[\(specialArguments[index])] - \(specialArgumentsDescriptions[index])")
        }
        print("\nConfiguration mode:".bold().cyan())
        var configArgumentsString = ""
        for argument in configurableParameters {
            configArgumentsString += "[\(argument)] "
        }
        print("Usage (set): ".bold() + "\n~/Mac@IBM.app/Contents/MacOS/Mac@IBM " + "[" + "--config".green() + "] " + configArgumentsString)
        print("Usage (reset): ".bold() + "\n~/Mac@IBM.app/Contents/MacOS/Mac@IBM " + "[" + "--config -reset".green() + "] " + configArgumentsString + "\n")
        for index in configurableParameters.indices {
            print("\(configurableParameters[index]):\n      \(configurableParametersDescriptions[index])")
        }
        print("\nReturn values:".bold().cyan())
        for index in returnValues.indices {
            print("\(returnValues[index]) - \(returnValuesDescription[index])")
        }
        print("\nUsage examples:".bold().cyan())
        print("- Popup UI - ".blue() + examplePopup)
        print("- Banner UI - ".blue() + exampleBanner)
        print("\n")
    }

    static func printNoArgumentsPage() {
        for index in specialArguments.indices {
            print("[\(specialArguments[index])] - \(specialArgumentsDescriptions[index])")
        }
    }

    static func printAppVersion() {
        print("Mac@IBM Notification Agent version: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "Unknown")".bold())
    }
}
