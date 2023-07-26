//
//  ControlActionClosureProtocol.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 09/02/23.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//  Credits: Sindre Sorhus (sindresorhus)
//

import SwiftUI

private var CACProtocolAssociatedObjectKey: UInt8 = 0

protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

extension ControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &CACProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSControl: ControlActionClosureProtocol {}
