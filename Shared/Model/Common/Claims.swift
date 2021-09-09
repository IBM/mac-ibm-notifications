//
//  Claims.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 18/06/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import SwiftJWT

struct MacAtIbmClaims: Claims {
    let sub: String
    let iss: String
    let exp: Date?
}
