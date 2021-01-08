//
//  DeepLinkEngineTests.swift
//  NotificationAgentTests
//
//  Created by Simone Martorelli on 7/15/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable trailing_whitespace

import Foundation
import XCTest
@testable import Mac_IBM_Notifications

class DeepLinkEngineTests: XCTestCase {
    func testURLParser() throws {
        let correctURLs = MockedData.correctURLs
        let faultyURLs = MockedData.faultyURLs
        
        for url in correctURLs {
            do {
                _ = try DeepLinkEngine.shared.parse(url)
                XCTAssert(true)
            } catch {
                XCTAssert(false)
            }
        }
        
        for url in faultyURLs {
            do {
                _ = try DeepLinkEngine.shared.parse(url)
                XCTAssert(false)
            } catch {
                XCTAssert(true)
            }
        }
    }
}
