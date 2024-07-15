//
//  Binding-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 11/01/23.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

extension Binding {
    
    /// When the `Binding`'s `wrappedValue` changes, the given closure is executed.
    /// - Parameter closure: Chunk of code to execute whenever the value changes.
    /// - Returns: New `Binding`.
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}
