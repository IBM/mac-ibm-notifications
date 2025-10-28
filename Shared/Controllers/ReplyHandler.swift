//
//  ReplyHandler.swift
//  Notification Agent
//
//  Created by Jan Valentik on 25/08/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa
import os.log
import UserNotifications

/// This class will handle the user response to the showed UI.
public final class ReplyHandler {

    // MARK: - Static variables

    static let shared = ReplyHandler()

    // MARK: - Variables

    let efclController = EFCLController.shared
    let context = Context.main

    // MARK: - Public methods

    /// Handle the response based on the type and on the showed NotificationObject.
    /// - Parameters:
    ///   - type: the type of the user response.
    ///   - object: the notification showed to the user.
    func handleResponse(ofType type: UserReplyType, for object: NotificationObject) {
        var triggerButton: NotificationButton?
        var exitReason: Utils.ExitReason?

        switch type {
        case .main:
            triggerButton = object.mainButton
            exitReason = .mainButtonClicked
        case .secondary:
            triggerButton = object.secondaryButton
            exitReason = .secondaryButtonClicked
        case .tertiary:
            triggerButton = object.tertiaryButton
            if object.type == .banner || object.tertiaryButton?.callToActionType == .exitlink {
                exitReason = .tertiaryButtonClicked
            }
        case .help:
            triggerButton = object.helpButton
        case .warning:
            triggerButton = object.warningButton
        case .dismiss:
            Utils.applicationExit(withReason: .userDismissedNotification)
        case .cancel:
            Utils.applicationExit(withReason: .cancelPressed)
        case .timeout:
            Utils.applicationExit(withReason: .timeout)
        }

        guard let button = triggerButton else { return }

        switch button.callToActionType {
        case .link, .exitlink:
            self.open(button.callToActionPayload)
            fallthrough
        default:
            guard let reason = exitReason else { return }
            Utils.applicationExit(withReason: reason)
        }
    }

    // MARK: - Private methods

    private func open(_ link: String) {
        guard let url = URL(string: link) else {
            NALogger.shared.log("Failed to create a valid URL or App path from payload: %{public}@", [link])
            return
        }
        if ProcessInfo.processInfo.environment["--isRunningTest"] == nil {
            NSWorkspace.shared.open(url)
        }
    }
}
