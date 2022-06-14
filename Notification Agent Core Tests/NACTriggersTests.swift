//
//  NACTriggersTests.swift
//  Notification Agent Core Tests
//
//  Created by Simone Martorelli on 26/05/22.
//  Copyright © 2022 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class NACTriggersTests: XCTestCase {

    let worker = TestWorker()
    let parserUseCases = [["toBeRemoved", "-type", "popup", "-title", "This is a title"],
                          ["toBeRemoved", "-type", "banner", "-title", "This is a title"],
                          ["toBeRemoved", "-type", "alert", "-title", "This is a title"],
                          ["toBeRemoved", "-type", "popup", "-title", "This is a title", "-silent", "-subtitle", "This is a subtitle"]]
    let processerUseCases = [URL(string: "macatibm:shownotification?type=popup&title=This%20is%20a%20title")!,
                             URL(string: "macatibm:shownotification?type=banner&title=This%20is%20a%20title")!,
                             URL(string: "macatibm:shownotification?type=alert&title=This%20is%20a%20title")!,
                             URL(string: "macatibm:shownotification?type=alert&title=title&silent&subtitle=This%20is%20a%20subtitle")!]
    
    override func setUpWithError() throws {
        worker.startObservation()
    }

    override func tearDownWithError() throws {
        worker.stopObservation()
    }

    func testArgumentParsing() throws {
        for useCase in parserUseCases {
            EFCLController.shared.parseArguments(useCase)
            XCTAssert(worker.argumentsSuccessfullyParsed, "Failed use case: \(useCase)")
            worker.argumentsSuccessfullyParsed = false
        }
    }
    
    func testURLProcessing() throws {
        for useCase in processerUseCases {
            DeepLinkEngine.shared.processURL(useCase)
            XCTAssert(worker.argumentsSuccessfullyParsed, "Failed use case: \(useCase)")
            worker.argumentsSuccessfullyParsed = false
        }
    }
}

extension NACTriggersTests {
    class TestWorker {
        var argumentsSuccessfullyParsed: Bool
        
        init() {
            argumentsSuccessfullyParsed = false
        }
        
        /// Adding notification observer
        func startObservation() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(receivedNotification),
                                                   name: .showNotification,
                                                   object: nil)
        }
        
        /// Removing notification observer
        func stopObservation() {
            NotificationCenter.default.removeObserver(self, name: .showNotification, object: nil)
        }

        @objc func receivedNotification(_ notification: NSNotification) {
            argumentsSuccessfullyParsed = true
        }
    }
}
