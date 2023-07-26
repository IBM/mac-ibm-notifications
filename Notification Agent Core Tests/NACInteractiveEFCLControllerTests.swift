//
//  NACInteractiveEFCLControllerTests.swift
//  Notification Agent Core Tests
//
//  Created by Simone Martorelli on 27/05/22.
//  Copyright © 2021 IBM. All rights reserved.
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
