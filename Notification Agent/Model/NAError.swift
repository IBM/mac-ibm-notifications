//
//  NAError.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 7/13/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

enum NAError {
    case dataFormat(type: Enums.ModelError)
    case deepLinkHandling(type: Enums.DeepLinkHandlingError)
    case efclController(type: Enums.EFCLControllerError)

    class Enums { }
}

extension NAError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataFormat(let type):
            return type.localizedDescription
        case .deepLinkHandling(let type):
            return type.localizedDescription
        case .efclController(let type):
            return type.localizedDescription
        }
    }
    var efclExitReason: EFCLController.ExitReason {
        switch self {
        case .efclController(let type):
            return type.efclExitReason
        default:
            return .internalError
        }
    }
}

// MARK: - Model Errors

extension NAError.Enums {
    enum ModelError {
        case noTypeDefined
        case noInfoToShow
        case noButtonDefined
        case noHelpButtonAllowedInNotification
    }
}

extension NAError.Enums.ModelError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noTypeDefined:
            return "No notification \"type\" parameter defined"
        case .noInfoToShow:
            return "No \"title\" or \"description\" or \"accessoryview\" parameters set. No info to show"
        case .noButtonDefined:
            return "No button defined"
        case .noHelpButtonAllowedInNotification:
            return "It's not allowed to define an help button in a \"banner\" UI type style."
        }
    }
}

// MARK: - DeepLinkEngine Errors

extension NAError.Enums {
    enum DeepLinkHandlingError {
        case failedToGetComponents
        case unsupportedPath
        case noParametersFound
    }
}

extension NAError.Enums.DeepLinkHandlingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToGetComponents:
            return "Failed to get URL's components"
        case .unsupportedPath:
            return "URL's path is not supported"
        case .noParametersFound:
            return "Failed to get URL's parameters"
        }
    }
}

// MARK: - Execution From Command Line Controller Errors

extension NAError.Enums {
    enum EFCLControllerError {
        case invalidArgumentsSyntax
        case invalidArgumentsFormat
        case errorBuildingNotificationObject(description: String)
    }
}

extension NAError.Enums.EFCLControllerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidArgumentsSyntax:
            return "Invalid arguments syntax."
        case .invalidArgumentsFormat:
            return String(format: "Invalid argument syntax.")
        case .errorBuildingNotificationObject(let description):
            return String(format: "Error while trying to create notification object from arguments: %@.", description)
        }
    }
    var efclExitReason: EFCLController.ExitReason {
        switch self {
        case .invalidArgumentsSyntax:
            return .invalidArgumentsSyntax
        case .invalidArgumentsFormat:
            return .invalidArgumentFormat
        case .errorBuildingNotificationObject:
            return .invalidArgumentFormat
        }
    }
}
