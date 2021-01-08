//
//  Notification_AgentUITests.swift
//  Notification Agent UITests
//
//  Created by Jan Valentik on 18/06/2020.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class PopupUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
//        NSWorkspace.shared.open(MockedData.correctURLs.first!)
        // Needs to define a bettere structure for UITests
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

//    func test01LaunchPopUp() throws {
//        XCTAssert(self.app.windows["Mac@IBM"].exists)
//    }
//
//    func test02ButtonsPresence() throws {
//        self.app.windows["Mac@IBM"].click()
//        XCTAssert(self.app.windows["Mac@IBM"].buttons["Remove"].exists)
//        XCTAssert(self.app.windows["Mac@IBM"].buttons["Cancel"].exists)
//    }
//
//    func test03PopupDismiss() throws {
//        self.app.windows["Mac@IBM"].buttons["Remove"].click()
//        XCTAssertFalse(self.app.windows["Mac@IBM"].exists)
//    }
}
