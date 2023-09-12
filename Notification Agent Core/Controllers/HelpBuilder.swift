//
//  HelpBuilder.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/27/20.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable type_body_length file_length
import Foundation

public final class HelpBuilder {
    static let popupArguments: [String] = ["-type".green(),
                                           "-bar_title".yellow(),
                                           "-title".yellow(),
                                           "-title_size".yellow(),
                                           "-subtitle".yellow(),
                                           "-icon_path".yellow(),
                                           "-icon_width".yellow(),
                                           "-icon_height".yellow(),
                                           "-accessory_view_type".yellow(),
                                           "-accessory_view_payload".yellow(),
                                           "-secondary_accessory_view_type".yellow(),
                                           "-secondary_accessory_view_payload".yellow(),
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
                                           "-warning_button_cta_type".yellow(),
                                           "-warning_button_cta_payload".yellow(),
                                           "-warning_button_visibility".yellow(),
                                           "-timeout".yellow(),
                                           "-always_on_top".yellow(),
                                           "-silent".yellow(),
                                           "-miniaturizable".yellow(),
                                           "-force_light_mode".yellow(),
                                           "-position".yellow(),
                                           "-popup_reminder".yellow(),
                                           "-retain_values".yellow(),
                                           "-background_panel".yellow(),
                                           "-unmovable".yellow(),
                                           "-disable_quit".yellow()]
    static let bannerArguments: [String] = ["-type".green(),
                                            "-title".yellow(),
                                            "-subtitle".yellow(),
                                            "-main_button_label".yellow(),
                                            "-main_button_cta_type".yellow(),
                                            "-main_button_cta_payload".yellow(),
                                            "-secondary_button_label".yellow(),
                                            "-secondary_button_cta_type".yellow(),
                                            "-secondary_button_cta_payload".yellow(),
                                            "-tertiary_button_label".yellow(),
                                            "-tertiary_button_cta_type".yellow(),
                                            "-tertiary_button_cta_payload".yellow(),
                                            "-notification_image".yellow()]
    static let onboardingArguments: [String] = ["-type".green(),
                                                "-payload".green(),
                                                "-always_on_top".yellow(),
                                                "-hide_title_bar_buttons".yellow(),
                                                "-background_panel".yellow(),
                                                "-unmovable".yellow(),
                                                "-timeout".yellow(),
                                                "-disable_quit".yellow()]
    static let systemAlertArguments: [String] = ["-type".green(),
                                                 "-title".yellow(),
                                                 "-subtitle".yellow(),
                                                 "-icon_path".yellow(),
                                                 "-main_button_label".yellow(),
                                                 "-main_button_cta_type".yellow(),
                                                 "-main_button_cta_payload".yellow(),
                                                 "-secondary_button_label".yellow(),
                                                 "-secondary_button_cta_type".yellow(),
                                                 "-secondary_button_cta_payload".yellow(),
                                                 "-tertiary_button_label".yellow(),
                                                 "-tertiary_button_cta_type".yellow(),
                                                 "-tertiary_button_cta_payload".yellow(),
                                                 "-silent".yellow(),
                                                 "-show_suppression_button".yellow()]
    static let popupDescriptions: [String] = ["[ popup ]".red() + "\n      The UI type of the notification.\n      Example: -type popup",
                                              "\n      The bar title.\n      Example: -bar_title \"Bar Title\"",
                                              "\n      The title of the notification.\n      Suggested length < 120 characters.\n      Allowed length < 240 characters.\n      Example: -title \"Title\"",
                                              "\n      The title font size.\n      Example: -title_size \"20\"",
                                              "\n      The subtitle of the notification. It supports MarkDown text.\n      Example: -subtitle \"Subtitle\"",
                                              "\n      The custom icon path/URL/SF Symbol name defined for this notification.\n      Example: -icon_path \"~/Icon/Path.png\"",
                                              "\n      The custom icon width defined for this notification. Max. width = 150\n      Example: -icon_width \"150\"",
                                              "\n      The custom icon height defined for this notification. Max. height = 300\n      Example: -icon_height \"150\"",
                                              "[ whitebox | timer | image | video | progressbar | input | secureinput | dropdown | html | htmlwhitebox | checklist | datepicker | slideshow ]".red() + "\n      The UI type for the needed accessory view.\n      Example: -accessory_view_type whitebox",
                                              "\n      The payload for the accessory view:\n      " +
                                              "- Text for " + "[ whitebox ]".red() + " view type;\n      " +
                                              "- Text for " + "[ timer ]".red() + " view type. This will be timer's label. Use \"%@\" to define timer's position inside the label. Use " + "[ -timeout ]".yellow() + " argument to define timer's duration;\n      " +
                                              "- File path/link for " + "[ image ]".red() + " view type;\n      " +
                                              "- Text with the format " + "\"/url TEXT /autoplay /delay INT\" ".green() + "for " + "[ video ]".red() + " view type;\n      " +
                                              "- Text with the format " + "\"/percent DOUBLE /top_message TEXT /bottom_message TEXT /user_interaction_enabled BOOL /user_interruption_allowed BOOL\" ".green() + "for " + "[ progressbar ]".red() + " view type;\n      " +
                                              "- Text with the format " + "\"/placeholder TEXT /title TEXT /value TEXT /required\" ".green() + "for the " + "[ input | secureinput ]".red() + " view type;\n      " +
                                              "- Text with the format " + "\"/list ITEM\\nITEM\\nITEM /selected INT /placeholder TEXT /title TEXT\" ".green() + "for " + "[ dropdown ]".red() + " view type;\n      " +
                                              "- Text with HTML format for " + "[ html | htmlwhitebox ]".red() + " view type;\n      " +
                                              "- Text with the format " + "\"/list ITEM\\nITEM\\nITEM /preselection ITEM_INDEX ITEM_INDEX ITEM_INDEX /required /complete /title TEXT /radio\" ".green() + "for " + "[ checklist ]".red() + " view type. To read more about the usage of /complete and /required look at the project wiki;\n      " +
                                              "- Text with the format " + "\"/title TEXT /preselection DATE WITH FORMAT yyyy-MM-dd hh:mm:ss /style TEXT /components TEXT\" ".green() + "for " + "[ datepicker ]".red() + " view type. To read more about the usage of /style and /components look at the project wiki;\n      " +
                                              "- Text with the format " + "\"/images URL\\nURL\\nURL /autoplay /delay INT\" ".green() + "for " + "[ slideshow ]".red() + " view type;\n      " +
                                              "Example 1: -accessory_view_payload \"This is the time left: %@\"\n      " +
                                              "Example 2: -accessory_view_payload \"/percent 0 /top_message This is the top message /bottom_message This is the bottom message\";\n      " +
                                              "Example 3: -accessory_view_payload \"/percent indeterminate /top_message This is the top message /bottom_message This is the bottom message\";\n      " +
                                              "Example 4: -accessory_view_payload \"<h1>Hello, world!</h1>this is a line of text<br><br><code>this is a code block<br>this is the second line of a code block</code><br>this is <span style=\"color: #ff0000\">red</span> text\"\n      " +
                                              "Example 5: -accessory_view_payload \"/images /path/to/image.jpg\\nhttps://www.url.to/image.png\\nhttps://www.url.to/image.png /autoplay /delay 3\".",
                                              "\n      Same as for accessory_view_type argument.",
                                              "\n      Same as for accessory_view_payload argument.",
                                              "\n      The label of the main button.\n      Example: -main_button_label \"Main button title\"",
                                              "[ none | link ]".red() + "\n      The call to action type for the main button (default: none -> exit).\n      Example: -main_button_cta_type link",
                                              "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -main_button_cta_payload \"URL\"",
                                              "\n      The label of the secondary button.\n      Example: -secondary_button_label \"Secondary button title\"",
                                              "[ none | link ]".red() + "\n      The call to action type for the secondary button (default: none -> exit).\n      Example: -secondary_button_cta_type link",
                                              "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -secondary_button_cta_payload \"URL\"",
                                              "\n      The label of the tertiary button.\n      Example: -tertiary_button_label \"Tertiary button title\"",
                                              "[ link | exitlink ]".red() + "\n      The call to action type for the tertiary button.\n      Example: -tertiary_button_cta_type link",
                                              "\n      A mandatory URL if " + "[ link ]".red() + " cta type defined, optional if " + "[ exitlink ]".red() + " cta defined.\n      Example: -tertiary_button_cta_payload \"URL\"",
                                              "[ link | infopopup ]".red() + "\n      The call to action type for the help button.\n      Example: -help_button_cta_type link",
                                              "\n      An URL for " + "[ link ]".red() + " cta type or text for " + "[ infopopup ]".red() + " cta type.\n      Example: -help_button_cta_payload \"URL\"",
                                              "\n      Same as for help_button_cta_type argument.",
                                              "\n      Same as for help_button_cta_payload argument.",
                                              "[ hidden | visible ]".red() + "\n      Since the warning button visibility is interactive it needs an initial state.\n      Example: -help_button_cta_type hidden",
                                              "\n      The timeout for the notification. After this amount of seconds the agent exit with the timeout exit code.\n      Example: -timeout 300",
                                              "\n      Flag that tells the agent to keep the pop-up always on top of the window hierarchy.\n      Example: -always_on_top",
                                              "\n      Flag that tells the agent to not reproduce any sound when the pop-up appear.\n      Example: -silent",
                                              "\n      Flag that allows the UI to show the \"miniaturize\" button for the pop-up window.\n      Example: -miniaturizable",
                                              "\n      Flag that force the UI in light mode.\n      Example: -force_light_mode",
                                              "[ center | top_right | top_left | bottom_right | bottom_left ]".red() + "\n      Tells the app where to place the pop-up window.\n      Example: -position center",
                                              "\n      A text payload to define the behavior of an optional reminder for the pop-up. The reminder is basically a timer at the end of which the pop-up is pushed again on top of the view hierarchy on screen. The payload format is: " + "\"/timeinterval <TIME_IN_SECONDS> /silent /repeat\" ".green() + "\n      Example: -popup_reminder \"/timeinterval 300\"",
                                              "\n      Flag that tells the agent to print the available accessory view outputs on any exit (main or secondary button clicked).",
                                              "[ opaque | translucent ]".red() + "\n      The style for the background panel that will cover all the screens.\n      Example: -background_panel opaque",
                                              "\n      Flag that make the UI unmovable for the user.\n      Example: -unmovable",
                                              "\n      Flag that tells the agent to ignore cmd+q shortcut.\n      Example: -disable_quit"]
    static let bannerDescriptions: [String] = ["[ banner | alert ]".red() + "\n      The UI type of the notification.\n      Example: -type banner",
                                               "\n      The title of the notification.\n      Example: -title \"Title\"",
                                               "\n      The subtitle of the notification. It supports MarkDown text.\n      Example: -subtitle \"Subtitle\"",
                                               "\n      The label of the main button.\n      Example: -main_button_label \"Main button title\"",
                                               "[ none | link ]".red() + "\n      The call to action type for the main button (default: none -> exit).\n      Example: -main_button_cta_type link",
                                               "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -main_button_cta_payload \"URL\"",
                                               "\n      The label of the secondary button.\n      Example: -secondary_button_label \"Secondary button title\"",
                                               "[ none | link ]".red() + "\n      The call to action type for the secondary button (default: none -> exit).\n      Example: -secondary_button_cta_type link",
                                               "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -secondary_button_cta_payload \"URL\"",
                                               "\n      The label of the tertiary button.\n      Example: -tertiary_button_label \"Tertiary button title\"",
                                               "[ none | link ]".red() + "\n      The call to action type for the tertiary button.\n      Example: -tertiary_button_cta_type link",
                                               "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -tertiary_button_cta_payload \"URL\"",
                                               "\n      The path (local or remote) or the base64 encoded representation of the image attached to this notification.\n      Example: -notification_image \"~/Icon/Path.png\""]
    static let onboardingDescriptions: [String] = ["[ onboarding ]".red() + "\n      The UI type of the notification.\n      Example: -type onboarding",
                                                   "\n      The json payload for the \"onboarding\" UI type. Please see more about this feature on the project wiki.",
                                                   "\n      Flag that tells the agent to keep the Onbording UI always on top of the window hierarchy.\n      Example: -always_on_top",
                                                   "\n      Flag that tells the agent to remove the title bar buttons for the Onbording UI.\n      Example: -hide_title_bar_buttons",
                                                   "[ opaque | translucent ]".red() + "\n      The style for the background panel that will cover all the screens.\n      Example: -background_panel opaque",
                                                   "\n      Flag that make the UI unmovable for the user.\n      Example: -unmovable",
                                                   "\n      The timeout for the onboarding. After this amount of seconds the agent exit with the timeout exit code.\n      Example: -timeout 300",
                                                   "\n      Flag that tells the agent to ignore cmd+q shortcut.\n      Example: -disable_quit"]
    static let systemAlertDescriptions: [String] = ["[ systemAlert ]".red() + "\n      The UI type of the notification.\n      Example: -type systemAlert",
                                                    "\n      The title of the notification.\n      Example: -title \"Title\"",
                                                    "\n      The subtitle of the notification.\n      Example: -subtitle \"Subtitle\"",
                                                    "\n      The custom icon path defined for this notification or an SF Symbol name.\n      Example: -icon_path \"~/Icon/Path.png\"",
                                                    "\n      The label of the main button.\n      Example: -main_button_label \"Main button title\"",
                                                    "[ none | link ]".red() + "\n      The call to action type for the main button (default: none -> exit).\n      Example: -main_button_cta_type link",
                                                    "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -main_button_cta_payload \"URL\"",
                                                    "\n      The label of the secondary button.\n      Example: -secondary_button_label \"Secondary button title\"",
                                                    "[ none | link ]".red() + "\n      The call to action type for the secondary button (default: none -> exit).\n      Example: -secondary_button_cta_type link",
                                                    "\n      An URL if " + "[ link ]".red() + " cta type defined.\n      Example: -secondary_button_cta_payload \"URL\"",
                                                    "\n      The label of the tertiary button.\n      Example: -tertiary_button_label \"Tertiary button title\"",
                                                    "[ link | exitlink ]".red() + "\n      The call to action type for the tertiary button.\n      Example: -tertiary_button_cta_type link",
                                                    "\n      A mandatory URL if " + "[ link ]".red() + " cta type defined, optional if " + "[ exitlink ]".red() + " cta defined.\n      Example: -tertiary_button_cta_payload \"URL\"",
                                                    "\n      Flag that tells the agent to not reproduce any sound when the pop-up appear.\n      Example: -silent",
                                                    "\n      Flag that tells the agent to show the suppression future notifications button on the UI. If checked by the user the agent will print \"suppressed\" in the output before exit.\n      Example: -showSuppressionButton"]
    static let popupSyntacticRules: [String] = ["At least one argument between" + " [ -title | -subtitle | -accessory_view_type + -accessory_view_payload ] ".red() + "must be defined to present a pop-up.",
                                                "By default tertiary button is not destructive. Use " + "[ exitlink ]".red() + " cta type to trigger a link (optional) and make it destructive for the pop-up.",
                                                "In general if a call to action type is defined for a button, must be defined also the related payload. Except for the cta types " + "[ none | exitlink ]".red() + "."]
    static let bannerSyntacticRules: [String] = ["At least one argument between" + " [ -title | -subtitle ] ".red() + "must be defined to present a banner.",
                                                 "In general if a call to action type is defined for a button, must be defined also the related payload."]
    static let systemAlertSyntacticRules: [String] = ["At least one argument between" + " [ -title | -subtitle ] ".red() + "must be defined to present a systemAlert."]
    static let popupNotes: [String] = ["If no call to action type defined for a button the default one is " + "[ none ]".red() + ", that simply return the exit code related to the clicked button.\n- \"/selected\" and \"/placeholder\" keys for " + "[ dropdown ]".red() + " accessory view payload are mutually exclusive."]
    static let systemAlertNotes: [String] = ["If no call to action type defined for a button the default one is " + "[ none ]".red()]
    static let bannerNotes: [String] = ["If no call to action type defined for a button the default one is " + "[ none ]".red() + ", that simply return the exit code related to the clicked button.\nAlert UI require additional configurations to work properly. Please refer to the related Github Wiki Page."]
    static let specialArguments: [String] = ["--help".blue(),
                                             "--version".blue(),
                                             "--terms".blue(),
                                             "--privacy".blue(),
                                             "--resetBanners".blue(),
                                             "--resetAlerts".blue(),
                                             "--v".blue()]
    static let specialArgumentsDescriptions: [String] = ["Show help's page",
                                                         "Show app's version",
                                                         "Shows the Terms & Conditions",
                                                         "Shows the Privacy Policy",
                                                         "Delete all the app's banners from Notification Center",
                                                         "Delete all the app's alerts from Notification Center",
                                                         "Verbose mode"]
    static let configurableParameters: [String] = ["-default_popup_bar_title".yellow(),
                                                   "-default_popup_icon_path".yellow(),
                                                   "-default_popup_timeout".yellow(),
                                                   "-default_main_button_label".yellow()]
    static let configurableParametersDescriptions: [String] = ["Default pop-up's bar title.\n      Example: -default_popup_bar_title \"Title\"",
                                                               "Path for the default pop-up's icon.\n      Example: -default_popup_icon_path \"~/Icon/Path.png\"",
                                                               "Default pop-up's background timeout.\n      Example: -default_popup_timeout 300",
                                                               "Default main button label.\n      Example: -default_main_button_label \"Label\""]
    static let popupReturnValues: [String] = ["0".bold(),
                                              "1".bold(),
                                              "2".bold(),
                                              "3".bold(),
                                              "4".bold(),
                                              "200".bold(),
                                              "201".bold(),
                                              "239".bold(),
                                              "250".bold(),
                                              "255".bold(),
                                              "260".bold()]
    static let popupReturnValuesDescription: [String] = ["Main button clicked.",
                                                         "Internal error.",
                                                         "Secondary button clicked.",
                                                         "Tertiary button clicked.",
                                                         "Timeout.",
                                                         "Untracked success.",
                                                         "Received SigInt.",
                                                         "User dimissed the popup.",
                                                         "Invalid number of arguments.",
                                                         "Invalid arguments syntax.",
                                                         "Unable to load resources"]
    static let bannerReturnValues: [String] = ["0".bold(),
                                               "1".bold(),
                                               "2".bold(),
                                               "3".bold(),
                                               "200".bold(),
                                               "239".bold(),
                                               "201".bold(),
                                               "250".bold(),
                                               "255".bold()]
    static let bannerReturnValuesDescription: [String] = ["Main button clicked.",
                                                          "Internal error.",
                                                          "Secondary button clicked.",
                                                          "Tertiary button clicked.",
                                                          "Untracked success.",
                                                          "User dimissed the notification banner.",
                                                          "Received SigInt.",
                                                          "Invalid number of arguments.",
                                                          "Invalid arguments syntax."]
    static let onboardingReturnValues: [String] = ["0".bold(),
                                                   "239".bold()]
    static let onboardingReturnValuesDescription: [String] = ["User did finish onboarding.",
                                                              "User dimissed the onboarding window."]
    static let examplePopup: String = "~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier -type popup -title \"Test title\" -subtitle \"Test subtitle\" -accessory_view_type whitebox -accessory_view_payload \"Test accessory view\" -main_button_label \"Main button\" -secondary_button_label \"Secondary button\" -tertiary_button_label \"Tertiary button\" -tertiary_button_cta_type link -tertiary_button_cta_payload \"https://www.ibm.com\" -help_button_cta_type infopopup -help_button_cta_payload \"Test help text\""
    static let exampleBanner: String = "~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier -type banner -title \"Test title\" -subtitle \"Test subtitle\" -main_button_label \"Main button\" -secondary_button_label \"Secondary button\" -tertiary_button_label \"Tertiary button\" -tertiary_button_cta_type link -tertiary_button_cta_payload \"https://www.ibm.com\""
    static let exampleAlert: String = "~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier -type alert -title \"Test title\" -subtitle \"Test subtitle\" -main_button_label \"Main button\" -secondary_button_label \"Secondary button\" -tertiary_button_label \"Tertiary button\" -tertiary_button_cta_type link -tertiary_button_cta_payload \"https://www.ibm.com\""
    static let exampleOnboarding: String = "~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier -type onboarding -payload \"{\\\"pages\\\":[{\\\"title\\\":\\\"First page's title\\\",\\\"subtitle\\\":\\\"First page's subtitle\\\",\\\"body\\\":\\\"First page's body\\\"}]}\""
    static let exampleSystemAlert: String = "~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier -type popup -title \"Test title\" -subtitle \"Test subtitle\" -icon_path \"path/to/icon.png\" -main_button_label \"Main button\" -secondary_button_label \"Secondary button\" -tertiary_button_label \"Tertiary button\" -tertiary_button_cta_type link -tertiary_button_cta_payload \"https://www.ibm.com\" -silent -showSuppressionButton"
    
    static func printHelp(_ arguments: [String]) {
        guard !arguments.contains("-popup") else {
            Self.printPopupHelp()
            return
        }
        guard !arguments.contains("-banner") else {
            Self.printBannerHelp()
            return
        }
        guard !arguments.contains("-alert") else {
            Self.printBannerHelp()
            return
        }
        guard !arguments.contains("-onboarding") else {
            Self.printOnboardingHelp()
            return
        }
        guard !arguments.contains("-systemAlert") else {
            Self.printSystemAlertHelp()
            return
        }
        guard !arguments.contains("-configuration") else {
            Self.printConfigurationHelp()
            return
        }
        print("\nIBM Notifier Help Page".bold().blue() + "\n")
        print("You can use:\n     --help -popup - To show help page about the pop-up UI;\n     --help -banner - To show help page about the banner (temporary banner notification) UI;\n     --help -alert - To show help page about the alert (persistent banner notification) UI;\n     --help -onboarding - To show help page about the onboarding UI;\n     --help -systemAlert - To show help page about the system alert UI;\n     --help -configuration - To show help page about the configuration mode.\n")
    }

    static func printPopupHelp() {
        print("\nIBM Notifier Popup UI".bold().blue() + "\n")
        var argumentsString = ""
        for argument in popupArguments {
            argumentsString += "[\(argument)] "
        }
        print("Usage: ".cyan().bold() + "\n~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier " + argumentsString + "\n")
        print("Color Legend: ".cyan().bold())
        print("Mandatory value".green() + " " + "Optional value".yellow() + "\n")
        print("Arguments details:".cyan().bold())
        for index in popupArguments.indices {
            print("\(popupArguments[index]): \(popupDescriptions[index])")
        }
        print("\nSyntactic rules:".bold().cyan())
        for index in popupSyntacticRules.indices {
            print("- \(popupSyntacticRules[index])")
        }
        print("\nBe aware of:".bold().cyan())
        for index in popupNotes.indices {
            print("- \(popupNotes[index])")
        }
        print("\nReturn values:".bold().cyan())
        for index in popupReturnValues.indices {
            print("\(popupReturnValues[index]) - \(popupReturnValuesDescription[index])")
        }
        print("\nUsage examples:".bold().cyan())
        print("- Popup UI - ".blue() + examplePopup)
        print("\n")
    }

    static func printBannerHelp() {
        print("\nIBM Notifier Banner and Alert UIs".bold().blue() + "\n")
        var argumentsString = ""
        for argument in bannerArguments {
            argumentsString += "[\(argument)] "
        }
        print("Usage: ".cyan().bold() + "\n~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier " + argumentsString + "\n")
        print("Color Legend: ".cyan().bold())
        print("Mandatory value".green() + " " + "Optional value".yellow() + "\n")
        print("Arguments details:".cyan().bold())
        for index in bannerArguments.indices {
            print("\(bannerArguments[index]): \(bannerDescriptions[index])")
        }
        print("\nBe aware of:".bold().cyan())
        for index in bannerNotes.indices {
            print("- \(bannerNotes[index])")
        }
        print("\nReturn values:".bold().cyan())
        for index in bannerReturnValues.indices {
            print("\(bannerReturnValues[index]) - \(bannerReturnValuesDescription[index])")
        }
        print("\nUsage examples:".bold().cyan())
        print("- Banner UI - ".blue() + exampleBanner)
        print("- Alert UI - ".blue() + exampleAlert)
        print("\n")
    }

    static func printOnboardingHelp() {
        print("\nIBM Notifier Onboarding UI".bold().blue() + "\n")
        var argumentsString = ""
        for argument in onboardingArguments {
            argumentsString += "[\(argument)] "
        }
        print("Usage: ".cyan().bold() + "\n~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier " + argumentsString + "\n")
        print("Color Legend: ".cyan().bold())
        print("Mandatory value".green() + " " + "Optional value".yellow() + "\n")
        print("Arguments details:".cyan().bold())
        for index in onboardingArguments.indices {
            print("\(onboardingArguments[index]): \(onboardingDescriptions[index])")
        }
        print("\nReturn values:".bold().cyan())
        for index in onboardingReturnValues.indices {
            print("\(onboardingReturnValues[index]) - \(onboardingReturnValuesDescription[index])")
        }
        print("\nUsage examples:".bold().cyan())
        print("- Onboarding UI - ".blue() + exampleOnboarding)
        print("\n")
    }
    
    static func printConfigurationHelp() {
        print("\nIBM Notifier Configuration Mode".bold().blue() + "\n")
        print("Configuration mode:".bold().cyan())
        var configArgumentsString = ""
        for argument in configurableParameters {
            configArgumentsString += "[\(argument)] "
        }
        print("Usage (set): ".bold() + "\n~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier " + "[" + "--config".green() + "] " + configArgumentsString)
        print("Usage (reset): ".bold() + "\n~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier " + "[" + "--config -reset".green() + "] " + configArgumentsString + "\n")
        for index in configurableParameters.indices {
            print("\(configurableParameters[index]):\n      \(configurableParametersDescriptions[index])")
        }
    }
    
    static func printSystemAlertHelp() {
        print("\nIBM Notifier System Alert UI".bold().blue() + "\n")
        var argumentsString = ""
        for argument in systemAlertArguments {
            argumentsString += "[\(argument)] "
        }
        print("Usage: ".cyan().bold() + "\n~/IBM\\ Notifier.app/Contents/MacOS/IBM\\ Notifier " + argumentsString + "\n")
        print("Color Legend: ".cyan().bold())
        print("Mandatory value".green() + " " + "Optional value".yellow() + "\n")
        print("Arguments details:".cyan().bold())
        for index in systemAlertArguments.indices {
            print("\(systemAlertArguments[index]): \(systemAlertDescriptions[index])")
        }
        print("\nSyntactic rules:".bold().cyan())
        for index in systemAlertSyntacticRules.indices {
            print("- \(systemAlertSyntacticRules[index])")
        }
        print("\nBe aware of:".bold().cyan())
        for index in systemAlertNotes.indices {
            print("- \(systemAlertNotes[index])")
        }
        print("\nReturn values:".bold().cyan())
        for index in popupReturnValues.indices {
            print("\(popupReturnValues[index]) - \(popupReturnValuesDescription[index])")
        }
        print("\nUsage examples:".bold().cyan())
        print("- System Alert UI - ".blue() + exampleSystemAlert)
        print("\n")
    }

    static func printNoArgumentsPage() {
        print("\nIBM Notifier".bold().blue() + "\n")
        for index in specialArguments.indices {
            print("[\(specialArguments[index])] - \(specialArgumentsDescriptions[index])")
        }
    }
    
    static func printPrivacyPolicy() {
        guard let url = Bundle.main.url(forResource: "PRIVACY POLICY", withExtension: "rtf") else { return }
        let opts : [NSAttributedString.DocumentReadingOptionKey : Any] =
            [.documentType : NSAttributedString.DocumentType.rtf]
        var attributes : NSDictionary?
        if let attributedString = try? NSAttributedString(url: url, options: opts, documentAttributes: &attributes) {
            print(attributedString.string)
        }
    }
    
    static func printTermsAndCondition() {
        guard let url = Bundle.main.url(forResource: "TERMS AND CONDITIONS", withExtension: "rtf") else { return }
        let opts : [NSAttributedString.DocumentReadingOptionKey : Any] =
            [.documentType : NSAttributedString.DocumentType.rtf]
        var attributes : NSDictionary?
        if let attributedString = try? NSAttributedString(url: url, options: opts, documentAttributes: &attributes) {
            print(attributedString.string)
        }
    }

    static func printAppVersion() {
        print("IBM Notifier version: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "Unknown")".bold())
    }
}

//  swiftlint:enable type_body_length file_length
