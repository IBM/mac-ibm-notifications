//
//  Claims.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 18/06/2021.
//  © Copyright IBM Corp. 2021, 2026
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import SwiftJWT

struct MacAtIbmClaims: Claims {
    let sub: String
    let iss: String
    let exp: Date?
}
