//
//  NAPTriggersTests.swift
//  Notification Agent Popups Tests
//
//  Created by Simone Martorelli on 01/06/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class NAPTriggersTests: XCTestCase {

    let worker = TestWorker()
    let parserUseCases = [["type" : "popup", "title" : "This is a title"],
                          ["type" : "popup", "subtitle" : "This is a subtitle"],
                          ["type" : "popup", "title" : "This is a title", "subtitle" : "This is a subtitle", "position" : "top_left"],
                          ["type" : "popup", "title" : "This is a title", "subtitle" : "This is a subtitle", "silent" : "true"]]
    
    override func setUpWithError() throws {
        worker.startObservation()
    }

    override func tearDownWithError() throws {
        worker.stopObservation()
    }

    func testArgumentParsing() throws {
        for useCase in parserUseCases {
            guard let notificationObject = try? NotificationObject(from: useCase),
                  let settings = Context.main.sharedSettings else {
                XCTAssert(false, "Failed use case: \(useCase)")
                return
            }
            let taskObject = TaskObject(notification: notificationObject, settings: settings)
            guard let jsonData = try? JSONEncoder().encode(taskObject) else {
                XCTAssert(false, "Failed use case: \(useCase)")
                return
            }
            print("Case: \(jsonData.base64EncodedString())")
            EFCLController.shared.parseArguments([jsonData.base64EncodedString()])
            XCTAssert(worker.argumentsSuccessfullyParsed, "Failed use case: \(useCase)")
            worker.argumentsSuccessfullyParsed = false
        }
    }
}

extension NAPTriggersTests {
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
