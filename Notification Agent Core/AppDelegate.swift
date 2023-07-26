//
//  AppDelegate.swift
//  Notification Agent
//
//  Created by Jan Valentik on 18/06/2021.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa
import os.log
import Signals
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let notificationDispatch = NotificationDispatch.shared
    let deepLinkEngine = DeepLinkEngine.shared
    let efclController = EFCLController.shared
    let context = Context.main
    var isConfigured: Bool = false
    
    private func configureApp(_ completion: @escaping () -> Void = {}) {
        guard !isConfigured else {
            completion()
            return
        }
        isConfigured = true
        notificationDispatch.startObservingForNotifications()
        efclController.parseArguments()
        completion()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Signals.trap(signal: .user(Int(SIGINT))) { _ in
            let ops = OperationQueue()
            ops.addOperation {
                NotificationDispatch.shared.taskManager.interruptUITasks()
            }
            ops.waitUntilAllOperationsAreFinished()
            EFCLController.shared.applicationExit(withReason: .receivedSigInt)
        }
        configureApp()
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        self.deepLinkEngine.agentTriggeredByDeepLink = true
        guard UserDefaults.standard.bool(forKey: "deeplinkSecurity") else {
            NALogger.shared.log("You need to enable deep link security to use deep link")
            EFCLController.shared.applicationExit(withReason: .unableToLoadResources)
            return
        }
        configureApp {
            for url in urls {
                NALogger.shared.log("IBM Notifier has been triggered by a URL", [url.absoluteString])
                self.deepLinkEngine.processURL(url)
            }
        }
    }
}
