//
//  Decodable-Extensions.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/01/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

extension Decodable {
    /// Initializing object decoding JSON format string.
    /// - Parameter json: the JSON format string.
    /// - Throws: deconding or data errors.
    init(from json: String) throws {
        guard let jsonData = json.data(using: .utf8) else {
            throw NAError.dataFormat(type: .invalidJSONPayload)
        }
        do {
            self = try JSONDecoder().decode(Self.self, from: jsonData)
        } catch let error {
            throw NAError.dataFormat(type: .invalidJSONDecoding(errorDescription: error.localizedDescription))
        }
    }
    /// Intializing obeject from decoding JSON file.
    /// - Parameter url: JSON file url.
    /// - Throws: deconding or url errors.
    init(from url: URL) throws {
        guard let jsonData = try? Data(contentsOf: url, options: .mappedIfSafe) else {
            throw NAError.dataFormat(type: .invalidJSONFilepath)
        }
        do {
            self = try JSONDecoder().decode(Self.self, from: jsonData)
        } catch let error {
            throw NAError.dataFormat(type: .invalidJSONDecoding(errorDescription: error.localizedDescription))
        }
    }
}
