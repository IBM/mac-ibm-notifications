//
//  ActionTrampoline.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 09/02/23.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//  Credits: Sindre Sorhus (sindresorhus)
//

import SwiftUI

final class ActionTrampoline<T>: NSObject {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    //  swiftlint:disable force_cast

    @objc
    func action(sender: AnyObject) {
        action(sender as! T)
    }
    
    //  swiftlint:enable force_cast
}
