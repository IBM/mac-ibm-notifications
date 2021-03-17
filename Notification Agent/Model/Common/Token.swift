//
//  Token.swift
//  Notification Agent
//
//  Created by Jan Valentik on 20/11/2020.
//  Copyright © 2020 IBM. All rights reserved.
//

import SwiftJWT
import Foundation

struct Token: Decodable {
    let jwtString: String
}

struct MacAtIbmClaims: Claims {
    let sub: String
    let iss: String
    let exp: Date?
}
