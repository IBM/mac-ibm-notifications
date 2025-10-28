//
//  InteractiveObjectProtocol.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 24/06/22.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

protocol InteractiveObjectProtocol {
    var objectIdentifier: String { get }
    func processInput(_ notification: Notification)
}

extension InteractiveObjectProtocol {
    func startObservingForUpdates() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: objectIdentifier), object: nil, queue: .main, using: self.processInput(_:))
    }
}
