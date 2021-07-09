//
//  Logger.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 8/27/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import os.log

/// A simple class based on Apple os.log that handle normal and verbose logs.
public final class Logger {
    var isVerboseModeOn: Bool = false
    static let shared = Logger()
    func log(_ type: OSLogType, _ message: StaticString, _ args: CVarArg...) {
        os_log(type, message, args)
        if isVerboseModeOn || type == .error {
            let message = type == .error ?
                message.description.replacingOccurrences(of: "{public}", with: "").red() :
                message.description.replacingOccurrences(of: "{public}", with: "")
            if let string = args.first as? String {
                print(String(format: message, string))
            } else if ((args.first as? [Any])?.count ?? 0) != 0 {
                print(message, args)
            } else {
                print(message)
            }
        }
    }
    func log(_ message: StaticString, _ args: CVarArg...) {
        log(.default, message, args)
    }
}
