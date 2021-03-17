//
//  Decodable-Extensions.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/01/2021.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension Decodable {
    init(from json: String) throws {
        guard let jsonData = json.data(using: .utf8) else {
            throw NAError.dataFormat(type: .invalidDecodingFromJSON)
        }
        self = try JSONDecoder().decode(Self.self, from: jsonData)
    }
}
