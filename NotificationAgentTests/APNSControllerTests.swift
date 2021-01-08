//
//  APNSControllerTests.swift
//  NotificationAgentTests
//
//  Created by Simone Martorelli on 8/11/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import XCTest
@testable import Mac_IBM_Notifications

class APNSControllerTests: XCTestCase {
    func testObserver() {
        let apnsController = APNSController.shared
        let correctFormatObject = MockedData.correctFormatDictionaries.first!
        let expct = expectation(description: "Notification propagated")

        let observer = NotificationCenter.default.addObserver(forName: .showNotification,
                                                              object: nil,
                                                              queue: .none) { _ in
            expct.fulfill()
        }

        apnsController.receivedRemoteNotification(with: correctFormatObject)

        waitForExpectations(timeout: 5) { (error) in
            XCTAssert(error == nil)
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
