//
//  NotificationDispatch-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 5/27/21.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa
import SwiftUI

extension NotificationDispatch {
    /// Handle the received notification and send the notification object to the correct controller.
    /// - Parameter notification: the received notification.
    @objc
    func receivedNotification(_ notification: Notification) {
        guard let object = notification.userInfo?["object"] as? NotificationObject else { return }
        guard let onboardingData = object.payload else { return }
        DispatchQueue.main.async {
            var mainWindow = NSWindow()
            mainWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 812, height: 600), styleMask: .titled, backing: .buffered, defer: false)
            guard let viewModel = OnboardingViewModel(onboardingData, window: mainWindow, position: object.position, timeout: object.timeout) else { return }
            mainWindow.delegate = viewModel
            let contentView = OnboardingView(viewModel: viewModel)
            mainWindow.contentView = NSHostingView(rootView: contentView)
            mainWindow.setWindowPosition(object.position ?? .center)
            mainWindow.styleMask.remove(.resizable)
            if object.payload?.progressBarPayload != nil {
                mainWindow.styleMask.remove(.closable)
                mainWindow.styleMask.remove(.miniaturizable)
            } else if object.hideTitleBarButtons ?? false {
                mainWindow.styleMask.remove(.closable)
                mainWindow.styleMask.remove(.miniaturizable)
            }
            mainWindow.canBecomeVisibleWithoutLogin = true

            if object.forceLightMode ?? false {
                NSApp.appearance = NSAppearance(named: .aqua)
            }
            mainWindow.title = ""
            mainWindow.titlebarAppearsTransparent = true
            
            if let backgroundPanelStyle = object.backgroundPanel {
                mainWindow.level = .init(Int(CGWindowLevelForKey(.maximumWindow)) + 2)
                mainWindow.isMovable = false
                mainWindow.collectionBehavior = [.stationary, .canJoinAllSpaces]
                Context.main.backgroundPanelsController = BackPanelController(backgroundPanelStyle)
                Context.main.backgroundPanelsController?.showBackgroundWindows()
            } else {
                mainWindow.isMovable = object.isMovable
                mainWindow.level = object.alwaysOnTop ?? false ? .floating : .normal
            }
            
            mainWindow.makeKeyAndOrderFront(self)
        }
    }
}
