//
//  UNNotificationAttachment-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 03/12/2021.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import UserNotifications

extension UNNotificationAttachment {
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) throws -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        guard let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true) else { return nil }
        try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
        let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
        try data.write(to: fileURL, options: [])
        let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
        return imageAttachment
    }
}
