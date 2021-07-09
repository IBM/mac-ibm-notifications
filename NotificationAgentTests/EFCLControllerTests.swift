//
//  EFCLControllerTests.swift
//  NotificationAgentTests
//
//  Created by Simone Martorelli on 9/3/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import XCTest
@testable import IBM_Notifier

class EFCLControllerTests: XCTestCase {
    let efclController = EFCLController.shared

    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
    }

    func test01CorrectArgumentList() {
        let list = MockedData.correctArgumentLists[0]
        let expct = expectation(description: "Notification propagated 01")
        let observer = NotificationCenter.default.addObserver(forName: .showNotification,
                                                              object: nil,
                                                              queue: .none) { _ in
                                                                DispatchQueue.main.async {
                                                                    expct.fulfill()
                                                                }
        }
        efclController.parseArguments(list)
        waitForExpectations(timeout: 5) { error in
            XCTAssert(error == nil)
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func test02CorrectArgumentList() {
        let list = MockedData.correctArgumentLists[2]
        let expct = expectation(description: "Notification propagated 02")
        let observer = NotificationCenter.default.addObserver(forName: .showNotification,
                                                              object: nil,
                                                              queue: .none) { _ in
                                                                DispatchQueue.main.async {
                                                                    expct.fulfill()
                                                                }
        }
        efclController.parseArguments(list)
        waitForExpectations(timeout: 5) { error in
            XCTAssert(error == nil)
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
