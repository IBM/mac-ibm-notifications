//
//  SystemAlertController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 17/08/22.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import AppKit

/// Handle the systemAlert UIs appearance and behavior.
final class SystemAlertController {
    
    // MARK: - Variables
    
    let notificationObject: NotificationObject
    let alert: NSAlert
    var suppressNotification: Bool
    
    // MARK: - Initializers
    
    init(_ object: NotificationObject) {
        notificationObject = object
        alert = NSAlert()
        suppressNotification = false
        setupAlert()
    }
    
    // MARK: - Private Methods
    
    /// Setup the alert layout, components and appearance.
    private func setupAlert() {
        alert.alertStyle = .informational
        
        // Setting up labels.
        alert.messageText = notificationObject.title ?? ""
        alert.informativeText = notificationObject.subtitle ?? ""
        
        // Setting up alert icon.
        if let iconPath = notificationObject.iconPath {
            if FileManager.default.fileExists(atPath: iconPath),
               let data = try? Data(contentsOf: URL(fileURLWithPath: iconPath)) {
                let image = NSImage(data: data)
                alert.icon = image
            } else if iconPath.isValidURL,
                      let url = URL(string: iconPath),
                      let data = try? Data(contentsOf: url) {
                let image = NSImage(data: data)
                alert.icon = image
            } else if let imageData = Data(base64Encoded: iconPath, options: .ignoreUnknownCharacters),
                      let image = NSImage(data: imageData) {
                alert.icon = image
            } else if let image = NSImage(systemSymbolName: iconPath, accessibilityDescription: nil) {
                alert.icon = image
            } else {
                NALogger.shared.log("Unable to load image from %{public}@", [iconPath])
            }
        }
        
        // Setting up buttons.
        let mainButton = alert.addButton(withTitle: notificationObject.mainButton.label)
        mainButton.action = #selector(self.didPressMainButton(_:))
        mainButton.target = self
        if let secondaryButton = notificationObject.secondaryButton {
            let secondaryButton = alert.addButton(withTitle: secondaryButton.label)
            secondaryButton.action = #selector(self.didPressSecondaryButton(_:))
            secondaryButton.target = self
        }
        if let tertiaryButton = notificationObject.tertiaryButton {
            let tertiaryButton = alert.addButton(withTitle: tertiaryButton.label)
            tertiaryButton.action = #selector(self.didPressTertiaryButton(_:))
            tertiaryButton.target = self
        }
        
        // Setting up help button.
        alert.showsHelp = false
        
        // Setting up suppression button.
        alert.showsSuppressionButton = notificationObject.showSuppressionButton ?? false
        alert.suppressionButton?.action = #selector(didPressSuppressButton(_:))
        alert.suppressionButton?.target = self
    }
    
    // MARK: - Public Methods
    
    /// Show the alert to the end user.
    func showAlert() {
        if !(notificationObject.silent ?? false) {
            NSSound(named: .init("Funk"))?.play()
        }
        alert.runModal()
        alert.window.setWindowPosition(notificationObject.position ?? .center)
    }
    
    // MARK: - Actions
    
    @objc
    private func didPressMainButton(_ sender: NSButton) {
        if suppressNotification { print("suppress") }
        ReplyHandler.shared.handleResponse(ofType: .main, for: notificationObject)
    }
    @objc
    private func didPressSecondaryButton(_ sender: NSButton) {
        if suppressNotification { print("suppress") }
        ReplyHandler.shared.handleResponse(ofType: .secondary, for: notificationObject)
    }
    @objc
    private func didPressTertiaryButton(_ sender: NSButton) {
        if suppressNotification { print("suppress") }
        ReplyHandler.shared.handleResponse(ofType: .tertiary, for: notificationObject)
    }
    @objc
    private func didPressSuppressButton(_ sender: NSButton) {
        suppressNotification = sender.state == .on
    }
}
