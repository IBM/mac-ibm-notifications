//
//  UserNotificationController.swift
//  NotificationAgent
//
//  Created by Simone Martorelli on 7/29/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable line_length

import Foundation
import UserNotifications
import os.log

/// Handle the requests to present user notification.
class UserNotificationController: NSObject {

    // MARK: - Static constants

    static let shared = UserNotificationController()
    var presentedNotifications: [NotificationObject] = []
    var replyHandler = ReplyHandler.shared
    let logger = Logger.shared

    // MARK: - Initializers

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Public methods

    /// Request the authorization to send User Notification.
    func registerForRichNotifications(_ completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                self.logger.log(.error,
                       "Mac@IBM Notification Agent rich notification autorization request ended with error: %{public}@",
                       error.localizedDescription)
            }
            if granted {
                self.logger.log("Mac@IBM Notification Agent rich notification autorization granted")
            } else {
                self.logger.log("Mac@IBM Notification Agent rich notification autorization not granted")
            }
            completion()
        }
    }

    /// Show to the user a control center notification that describe the notification object received.
    /// - Parameter notificationObject: the notification object that needs to be show.
    func showBanner(_ notificationObject: NotificationObject) {
        let userNotificationContent = UNMutableNotificationContent()
        let userNotificationRequestIdentifier = notificationObject.identifier.uuidString

        userNotificationContent.title = notificationObject.title ?? ""
        userNotificationContent.body = notificationObject.subtitle ?? ""
        var actions: [UNNotificationAction] = []
        if let tertiaryButton = notificationObject.tertiaryButton {
            let actionThree = UNNotificationAction(identifier: tertiaryButton.label, title: tertiaryButton.label, options: [.authenticationRequired])
            actions.insert(actionThree, at: 0)
        }
        if let secondaryButton = notificationObject.secondaryButton {
            let actionTwo = UNNotificationAction(identifier: secondaryButton.label, title: secondaryButton.label, options: [.authenticationRequired])
            actions.insert(actionTwo, at: 0)
        }
        if !actions.isEmpty || notificationObject.mainButton.label != "default_main_button_label".localized {
            let actionOne = UNNotificationAction(identifier: notificationObject.mainButton.label, title: notificationObject.mainButton.label, options: [.authenticationRequired])
            actions.insert(actionOne, at: 0)
        }
        // Archiving notification object inside a Data object in order to add it to the userinfo of the UNMutableNotificationContent.
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: notificationObject, requiringSecureCoding: true) else {
            self.logger.log(.error, "Unable to encode notification object for UNNotificationContent userinfo")
            EFCLController.shared.applicationExit(withReason: .internalError)
            return
        }
        userNotificationContent.userInfo = ["notificationObject": data]
        let category = UNNotificationCategory(identifier: UUID().uuidString, actions: actions, intentIdentifiers: [], options: [.customDismissAction])
        UNUserNotificationCenter.current().setNotificationCategories([category])

        userNotificationContent.categoryIdentifier = category.identifier
        userNotificationContent.sound = UNNotificationSound.default

        let userNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)

        let request = UNNotificationRequest(identifier: userNotificationRequestIdentifier,
                                            content: userNotificationContent,
                                            trigger: userNotificationTrigger)

        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else {
                self.logger.log(.error,
                       "Mac@IBM Notification Agent rich notification center failed to send request: %{public}@", request)
                return
            }
            self.logger.log("Mac@IBM Notification Agent rich notification center sent request: %{public}@", request)
            self.presentedNotifications.append(notificationObject)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension UserNotificationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       logger.log("Mac@IBM Notification Agent rich notification user response: %{public}@", response.actionIdentifier)
        guard let notificationObjectData = response.notification.request.content.userInfo["notificationObject"] as? Data,
              let notificationObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NotificationObject.self, from: notificationObjectData) else {
            self.logger.log(.error, "Unable to decode notification object from UNNotificationResponse")
            EFCLController.shared.applicationExit(withReason: .internalError)
            return
        }
        var actionType: ReplyHandler.ReplyType!
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            actionType = .dismiss
        case UNNotificationDefaultActionIdentifier:
            actionType = .main
        case notificationObject.mainButton.label:
            actionType = .main
        case notificationObject.secondaryButton?.label:
            actionType = .secondary
        case notificationObject.tertiaryButton?.label:
            actionType = .tertiary
        default:
            logger.log(.error, "User triggered action with untracked identifier, inspect the case with the developers. Identifier: %{public}@", response.actionIdentifier)
            return
        }
        replyHandler.handleResponse(ofType: actionType, for: notificationObject)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}
