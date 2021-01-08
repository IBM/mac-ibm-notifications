//
//  ReplyHandler.swift
//  NotificationAgent
//
//  Created by Jan Valentik on 25/08/2020.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa
import os.log

/// This class will handle the user response to the showed UI.
public final class ReplyHandler {

    // MARK: - Static variables

    /// All the different kind of response that the UI could receive from the user.
    enum ReplyType: String {
        case main // Click on the main button (or on the notification banner for "banner" UI type).
        case secondary // Click on the secondary button.
        case tertiary // Click on the tertiary button.
        case help // Click on the help button. Help button type "infoPopup" is managed in the viewController itself.
        case dismiss // "banner" UI type UI dismissed.
        case cancel // "Cancel" button pressed on popup.
    }

    // MARK: - Static variables

    static let shared = ReplyHandler()

    // MARK: - Variables

    let efclController = EFCLController.shared
    let logger = Logger.shared

    // MARK: - Public methods

    /// Handle the response based on the type and on the showed NotificationObject.
    /// - Parameters:
    ///   - type: the type of the user response.
    ///   - object: the notification showed to the user.
    ///   - completion: call back to notify it completed the actions.
    func handleResponse(ofType type: ReplyType, for object: NotificationObject) {
        var triggerButton: NotificationButton?
        var exitReason: EFCLController.ExitReason?

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
        case .dismiss:
            efclController.applicationExit(withReason: .userDismissedNotification)
        case .cancel:
            efclController.applicationExit(withReason: .cancelPressed)
        }

        guard let button = triggerButton else { return }

        switch button.callToActionType {
        case .link, .exitlink:
            self.open(button.callToActionPayload)
            fallthrough
        default:
            guard let reason = exitReason else { return }
            efclController.applicationExit(withReason: reason)
        }
    }

    // MARK: - Private methods

    private func open(_ link: String) {
        guard let url = URL(string: link) else {
            if NSWorkspace.shared.openFile(link) { return }
            logger.log(.error, "Failed to create a valid URL or App path from call to action payload: %{public}@", link)
            return
        }
        if ProcessInfo.processInfo.environment["--isRunningTestForCommandLine"] == nil {
            NSWorkspace.shared.open(url)
        }
    }
}
