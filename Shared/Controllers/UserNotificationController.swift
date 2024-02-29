//
//  UserNotificationController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/29/20.
//  Copyright © 2021 IBM. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable function_body_length

import Foundation
import Cocoa
import UserNotifications
import os.log

/// Handle the requests to present user notification.
class UserNotificationController: NSObject {

    // MARK: - Static constants

    static let shared = UserNotificationController()
    var presentedNotifications: [NotificationObject] = []
    var replyHandler = ReplyHandler.shared
    let context = Context.main
    var agentTriggeredByNotificationCenter: Bool = false

    // MARK: - Initializers

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Public methods

    /// Request the authorization to send User Notification.
    func registerForRichNotificationsIfNeeded(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                NALogger.shared.log(.error,
                       "Rich notification authorization request ended with error: %{public}@",
                       [error.localizedDescription])
                Utils.applicationExit(withReason: .internalError)
                completion(false)
            }
            if granted {
                NALogger.shared.log("Rich notification authorization granted")
                completion(true)
            } else {
                NALogger.shared.log("Rich notification authorization not granted")
                completion(false)
            }
        }
    }

    /// Show to the user a control center notification that describe the notification object received.
    /// - Parameter notificationObject: the notification object that needs to be show.
    func showBanner(_ notificationObject: NotificationObject) {
        if let workflow = notificationObject.workflow, workflow == .resetBanners || workflow == .resetAlerts {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            Utils.applicationExit(withReason: .untrackedSuccess)
            return
        }
        registerForRichNotificationsIfNeeded { success in
            guard success else { return }
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
                NALogger.shared.log("Unable to encode notification object for UNNotificationContent userinfo")
                Utils.applicationExit(withReason: .internalError)
                return
            }
            if let imagePath = notificationObject.notificationImage {
                var imageData: Data? {
                    if FileManager.default.fileExists(atPath: imagePath),
                       let data = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) {
                        return data
                    } else if imagePath.isValidURL,
                              let url = URL(string: imagePath),
                              let data = try? Data(contentsOf: url) {
                        return data
                    } else if let data = Data(base64Encoded: imagePath, options: .ignoreUnknownCharacters) {
                        return data
                    } else {
                        return nil
                    }
                }
                do {
                    if let data = imageData,
                       let attachment = try UNNotificationAttachment.create(imageFileIdentifier: "image.png", data: data as NSData, options: nil) {
                        userNotificationContent.attachments = [attachment]
                    }
                } catch {
                    NALogger.shared.log("")
                }
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
                    NALogger.shared.log(.error,
                                    "Rich notification center failed to send request: %{public}@", [request.description])
                    Utils.applicationExit(withReason: .internalError)
                    return
                }
                NALogger.shared.log("Rich notification center sent request: %{public}@", [request.description])
                self.presentedNotifications.append(notificationObject)
            }
        }
    }
}

//  swiftlint:enable function_body_length

// MARK: - UNUserNotificationCenterDelegate

extension UserNotificationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.agentTriggeredByNotificationCenter = true
        NALogger.shared.log("Rich notification user response: %{public}@", [response.actionIdentifier])
        guard let notificationObjectData = response.notification.request.content.userInfo["notificationObject"] as? Data,
              let notificationObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NotificationObject.self, from: notificationObjectData) else {
            Utils.applicationExit(withReason: .untrackedSuccess)
            return
        }
        var actionType: UserReplyType!
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
            NALogger.shared.log("User triggered action with untracked identifier, inspect the case with the developers. Identifier: %{public}@", [response.actionIdentifier])
            Utils.applicationExit(withReason: .untrackedSuccess)
            return
        }
        replyHandler.handleResponse(ofType: actionType, for: notificationObject)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
}
