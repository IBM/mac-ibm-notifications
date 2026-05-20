//
//  Collection-Extension.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/05/2023.
//  © Copyright IBM Corp. 2021, 2026
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
