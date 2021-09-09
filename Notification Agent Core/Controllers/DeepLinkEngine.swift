//
//  DeepLinkEngine.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 6/22/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import os.log
import SwiftJWT

/// Handle the deeplink that triggered the agent.
final class DeepLinkEngine {

    // MARK: - Static constants

    static let shared = DeepLinkEngine()

    // MARK: - Constants

    private let notificationPath: String = "shownotification"
    let context = Context.main
    var agentTriggeredByDeepLink: Bool = false

    // MARK: - Methods

    /// Process the received url and propagate a notification if can build a correct notification object from it.
    /// - Parameter url: the received url.
    func processURL(_ url: URL) {
        NALogger.shared.log("Parsing the received URL")
        do {
            let notificationObject = try parse(url)
            NALogger.shared.log("Ended parsing received URL")
            
            // Propagates the received notification
            NotificationCenter.default.post(name: .showNotification, object: self, userInfo: ["object" : notificationObject])
        } catch {
            NALogger.shared.log("Error: %{public}@. No UI will be showed for the URL", [error.localizedDescription])
        }
    }

    /// Parse the received url and returns a notification object.
    /// - Parameter url: url received.
    /// - Throws: parsing errors.
    /// - Returns: notification object to be showed to the user.
    func parse(_ url: URL) throws -> NotificationObject {
        // Parse the URL - BEGIN
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NAError.deepLinkHandling(type: .failedToGetComponents)
        }
        
        // Get the URL path.
        guard let path = components.path, path == notificationPath else {
            throw NAError.deepLinkHandling(type: .unsupportedPath)
        }
        
        // Get the URL parameters.
        guard let params = components.queryItems else {
            throw NAError.deepLinkHandling(type: .noParametersFound)
        }
        
        // Transform [QueryItems] in [String: String]
        var dict: [String: String] = [:]
        dict = params.reduce(into: [:]) {(dict, item) in
            return dict[item.name] = item.value ?? ""
        }
        dict = dict.filter({ $0.value != "" })
        if UserDefaults.standard.bool(forKey: "deeplinkSecurity") {
            guard let token = dict["token"], verifyToken(token: Token(value: token)) else {
                throw NAError.deepLinkHandling(type: .invalidToken)
            }
        }
        // Parse the URL - END
        
        let notificationObject = try NotificationObject(from: dict)
        return notificationObject
    }

    func verifyToken(token: Token) -> Bool {
        guard let publicKeyString = UserDefaults.standard.string(forKey: "deeplinkSecurityKey"),
              let publickKeyData = publicKeyString.data(using: .utf8) else { return false }
        let jwtVerifier = JWTVerifier.rs256(publicKey: publickKeyData)
        guard let verified = try? JWT<MacAtIbmClaims>(jwtString: token.value, verifier: jwtVerifier) else {
            return false
        }
        let validationResult = verified.validateClaims()

        return validationResult == .success && JWT<MacAtIbmClaims>.verify(token.value, using: jwtVerifier)
    }
}
