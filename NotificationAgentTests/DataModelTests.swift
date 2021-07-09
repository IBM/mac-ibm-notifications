//
//  DataModelTests.swift
//  NotificationAgentTests
//
//  Created by Simone Martorelli on 7/13/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import XCTest
@testable import IBM_Notifier

class DataModelTests: XCTestCase {
    func testNotificationObjectDictionary() throws {
        let correctFormatObjects = MockedData.correctFormatDictionaries
        let wrongFormatObject = MockedData.wrongFormatDictionaries
        
        for dict in correctFormatObjects {
            do {
                _ = try NotificationObject(from: dict)
                XCTAssert(true)
            } catch {
                XCTAssert(false)
            }
        }
        for dict in wrongFormatObject {
            do {
                _ = try NotificationObject(from: dict)
                XCTAssert(false)
            } catch {
                XCTAssert(true)
            }
        }
    }
}
