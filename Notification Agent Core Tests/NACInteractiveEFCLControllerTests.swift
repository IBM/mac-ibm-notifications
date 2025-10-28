//
//  NACInteractiveEFCLControllerTests.swift
//  Notification Agent Core Tests
//
//  Created by Simone Martorelli on 27/05/22.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class NACInteractiveEFCLControllerTests: XCTestCase {
    
    func testInteractiveEFCLPipe() throws {
        let controller = InteractiveEFCLController()
        controller.startObservingStandardInput()
        XCTAssert(controller.inputPipe != nil)
    }
}
