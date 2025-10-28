//
//  AppDelegate.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 18/06/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let notificationDispatch = NotificationDispatch.shared
    let efclController = EFCLController.shared
    let context = Context.main
    var isConfigured: Bool = false

    private func configureApp(_ completion: @escaping () -> Void = {}) {
        guard !isConfigured else {
            completion()
            return
        }
        isConfigured = true
        NSApplication.shared.activate(ignoringOtherApps: true)
        notificationDispatch.startObservingForNotifications()
        efclController.parseArguments()
        AppComponent.current.cleanSavedFiles()
        completion()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Intercept the command+q shortcut and modify the exit value to reflect a manual user dismission.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.command] where event.characters == "q":
                guard !self.context.disableQuit else { return .none }
                Utils.applicationExit(withReason: .userDismissedOnboarding)
            default:
                return event
            }
            return event
        }
        configureApp()
    }
}
