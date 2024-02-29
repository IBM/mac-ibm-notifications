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
        switch object.type {
        case .systemalert:
            DispatchQueue.main.async {
                let alertController = SystemAlertController(object)
                alertController.showAlert()
            }
        case .popup:
            DispatchQueue.main.async {
                let windowWidth = CGFloat(truncating: NumberFormatter().number(from: object.customWidth ?? "520") ?? .init(integerLiteral: 520))
                let mainWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: windowWidth, height: 130), styleMask: .titled, backing: .buffered, defer: false)
                let viewModel = PopUpViewModel(object, window: mainWindow)
                let contentView = PopUpView(viewModel: viewModel)
                let hostingView = NSHostingView(rootView: contentView)
                mainWindow.contentView = hostingView
                if object.hideTitleBar {
                    mainWindow.title = ""
                    mainWindow.titlebarAppearsTransparent = true
                } else {
                    mainWindow.title = object.barTitle ?? ConfigurableParameters.defaultPopupBarTitle
                }
                mainWindow.setWindowPosition(object.position ?? .center)
                mainWindow.styleMask.remove(.resizable)
                mainWindow.styleMask.remove(.closable)
                mainWindow.canBecomeVisibleWithoutLogin = true
                mainWindow.setAccessibilityIdentifier("main_window")
                
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
                
                if object.forceLightMode ?? false {
                    NSApp.appearance = NSAppearance(named: .aqua)
                }
                if !(object.isMiniaturizable ?? false) {
                    mainWindow.styleMask.remove(.miniaturizable)
                }
                
                mainWindow.makeKeyAndOrderFront(self)
                
                guard object.silent == false else { return }
                guard Utils.UISoundEffectStatusEnable else { return }
                NSSound(named: .init("Funk"))?.play()
            }
        default:
            Utils.applicationExit(withReason: .internalError)
        }
    }
}
