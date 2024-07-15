//
//  ACVDecoder.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 15/12/22.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

protocol ACVDecodable {
    init(stringLiteral: String)
}

protocol AVCIterable: CaseIterable, CodingKey {}

struct ACVDecoder {
    
    var codingKeys: any Collection<any CodingKey>
    
    //  swiftlint:disable force_cast

    init<T>(codingKeys: T.Type) where T : AVCIterable {
        self.codingKeys = codingKeys.allCases as! [any CodingKey]
    }
    
    //  swiftlint:enable force_cast
    
    // MARK: - Private Methods
    
    func decode<T>(key: CodingKey, ofType type: T.Type, from payload: String) throws -> T where T : ACVDecodable {
        guard codingKeys.contains(where: { $0.stringValue == key.stringValue }) else {
            throw NAError.efclController(type: .invalidAccessoryViewPayload)
        }
        
        var splittedStrings = payload.replacingOccurrences(of: "//", with: "/#escaping-double-slash /").split(separator: "/")
        guard splittedStrings.count > 0 else { throw NAError.efclController(type: .invalidAccessoryViewPayload) }
        splittedStrings.reverse()
        
        for index in 0..<splittedStrings.count {
            guard let argument = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false).first?.lowercased() else { continue }
            let value = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).last?.trimmingCharacters(in: CharacterSet.whitespaces)
            if argument == key.stringValue {
                if type is Bool.Type {
                    return type.init(stringLiteral: "true")
                }
                guard let value = value, !value.isEmpty else {
                    throw NAError.efclController(type: .invalidAccessoryViewPayload)
                }
                return type.init(stringLiteral: value)
            } else if codingKeys.filter({ $0.stringValue != key.stringValue }).contains(where: { $0.stringValue == argument }) {
                continue
            } else if argument == "#escaping-double-slash"{
                if index < splittedStrings.count-1 {
                    splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index].replacingOccurrences(of: "#escaping-double-slash ", with: ""))"))
                }
            } else {
                if index < splittedStrings.count-1 {
                    splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index])"))
                }
            }
        }
        return type.init(stringLiteral: "")
    }
}

extension String: ACVDecodable {}

extension Bool: ACVDecodable {
    init(stringLiteral: String) {
        self = stringLiteral.lowercased() == "true"
    }
}

extension [PickerItem]: ACVDecodable {
    init(stringLiteral: String) {
        var someArray: [PickerItem] = []
        for (index, line) in stringLiteral.lines.enumerated() where !someArray.contains(where: { $0.label == line }) {
            someArray.append(PickerItem(index: index, label: line, isSelected: false))
        }
        self = someArray
    }
}

extension Int: ACVDecodable {
    init(stringLiteral: String) {
        self = .init(stringLiteral) ?? 0
    }
}
