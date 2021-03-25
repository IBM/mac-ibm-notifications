//
//  AccessoryViewsTests.swift
//  NotificationAgentTests
//
//  Created by Simone Martorelli on 8/11/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import XCTest
@testable import Mac_IBM_Notifications

class AccessoryViewsTests: XCTestCase {
    func testTimerAccessoryView() {
        let timerAccessoryView = TimerAccessoryView(withTimeInSeconds: 5, label: "%@")
        let spyDelegate = SpyTimerAccessoryViewDelegate()
        timerAccessoryView.delegate = spyDelegate
        spyDelegate.asyncExpectation = expectation(description: "Timer did finished")
        waitForExpectations(timeout: 10) { error in
          XCTAssert(error == nil)
        }
    }
}

class SpyTimerAccessoryViewDelegate: TimerAccessoryViewDelegate {
    var asyncExpectation: XCTestExpectation?

    func timerDidFinished(_ sender: TimerAccessoryView) {
        guard let expectation = asyncExpectation else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        expectation.fulfill()
    }
}
