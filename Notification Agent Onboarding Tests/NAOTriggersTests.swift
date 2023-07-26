//
//  NAOTriggersTests.swift
//  Notification Agent Onboarding Tests
//
//  Created by Simone Martorelli on 01/06/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class NAOTriggersTests: XCTestCase {

    let worker = TestWorker()
    let jsonObject: [String : Any] = [
        "pages" : [
            [
                "title": "This is a title",
                "subtitle": "This is a subtitle",
                "body": "Some body",
                "accessoryViews": [
                    [
                        [
                            "type": "input",
                            "payload": "/placeholder Some /title First"
                        ],
                        [
                            "type": "input",
                            "payload": "/placeholder Some /title Second"
                        ]
                    ]
                ]
            ] as [String : Any],
            [
                "title": "This is a title",
                "subtitle": "This is a subtitle",
                "body": "Some body",
                "accessoryViews": [
                    [
                        [
                            "type": "input",
                            "payload": "/placeholder Some /title First"
                        ],
                        [
                            "type": "input",
                            "payload": "/placeholder Some /title Second"
                        ]
                    ]
                ]
            ]
        ]
    ]
    
    override func setUpWithError() throws {
        worker.startObservation()
    }

    override func tearDownWithError() throws {
        worker.stopObservation()
    }

    func testArgumentParsing() throws {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            XCTAssert(false)
            return
        }
        let useCase: [String : Any] = ["type" : "onboarding", "payload" : jsonString]
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
        print(jsonData.base64EncodedString())
        EFCLController.shared.parseArguments([jsonData.base64EncodedString()])
        XCTAssert(worker.argumentsSuccessfullyParsed, "Failed use case: \(useCase)")
        worker.argumentsSuccessfullyParsed = false
    }
}

extension NAOTriggersTests {
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
