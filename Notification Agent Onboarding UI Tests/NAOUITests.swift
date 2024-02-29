//
//  NAOUITests.swift
//  Notification Agent Onboarding UI Tests
//
//  Created by Simone Martorelli on 08/06/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class NAOUITests: XCTestCase {

    /// Testing simple Onboarding UI
    func testA1Onboarding() throws {
        let useCase = """
{"notification":{"retainValues":false,"isMovable":true,"type":"onboarding","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"barTitle":"IBM Notifier","alwaysOnTop":false,"showSuppressionButton":false,"hideTitleBarButtons":false,"accessoryViews":[],"payload":{"pages":[{"infoSection":{"fields":[{"id":"BE8ACDC6-1159-421E-8ECA-F84B6B6785ED","label":"Some Description Some"},{"id":"4C045585-72C2-428B-B574-F55CF86E5DCA","label":"Some Description Some"},{"id":"EF546A45-64CA-473D-8BEA-4BF18C3D624F","label":"Some Description Some"}]},"topIcon":"square.and.arrow.up","subtitle":"First page's subtitle","title":"First page's title","body":"First page's body"},{"singleChange":true,"infoSection":{"fields":[{"label":"First label only","id":"031F8516-F122-4A7D-A53C-4F41C9A6C86A"},{"id":"9A2DE192-E512-484E-B42B-2215C84A0B97","label":"Second label only"},{"label":"Third label only","id":"B9F441F5-E55D-4C71-B0BC-53347A4CE6A4"}]},"tertiaryButton":{"callToActionPayload":"https:\\/\\/www.google.com","label":"Tertiary","callToActionType":"link"},"title":"Second page's title","body":"Second page's body","primaryButtonLabel":"Some","subtitle":"Second page's subtitle"},{"title":"Third page's title","body":"Third page's body","singleChange":true,"subtitle":"Third page's subtitle"},{"body":"Fourth page's body","subtitle":"Fourth page's subtitle","title":"Fourth page's title"}],"progressBarPayload":"automatic"},"silent":false,"forceLightMode":false,"disableQuit":false,"buttonless":false,"hideTitleBar":false,"miniaturizable":false,"topicID":"untracked","notificationID":"untracked"},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
""" // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(!app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["help_button"].exists)
            app.buttons["main_button"].tap()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["tertiary_button"].exists)
            XCTAssert(app.buttons["help_button"].exists)
            app.buttons["main_button"].tap()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(!app.buttons["secondary_button"].exists)
            app.buttons["main_button"].tap()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(!app.buttons["secondary_button"].exists)
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing simple Onboarding UI with accessory views.
    func testA2Onboarding() throws {
        let useCase = """
{"notification":{"retainValues":false,"isMovable":true,"type":"onboarding","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"barTitle":"IBM Notifier","alwaysOnTop":false,"showSuppressionButton":false,"hideTitleBarButtons":false,"accessoryViews":[],"payload":{"pages":[{"accessoryViews":[[{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"},{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]],"infoSection":{"fields":[{"id":"BE8ACDC6-1159-421E-8ECA-F84B6B6785ED","label":"Some Description Some"},{"id":"4C045585-72C2-428B-B574-F55CF86E5DCA","label":"Some Description Some"},{"id":"EF546A45-64CA-473D-8BEA-4BF18C3D624F","label":"Some Description Some"}]},"topIcon":"square.and.arrow.up","subtitle":"First page's subtitle","title":"First page's title","body":"First page's body"},{"singleChange":true,"infoSection":{"fields":[{"label":"First label only","id":"031F8516-F122-4A7D-A53C-4F41C9A6C86A"},{"id":"9A2DE192-E512-484E-B42B-2215C84A0B97","label":"Second label only"},{"label":"Third label only","id":"B9F441F5-E55D-4C71-B0BC-53347A4CE6A4"}]},"tertiaryButton":{"callToActionPayload":"https:\\/\\/www.google.com","label":"Tertiary","callToActionType":"link"},"title":"Second page's title","body":"Second page's body","primaryButtonLabel":"Some","subtitle":"Second page's subtitle"},{"title":"Third page's title","body":"Third page's body","singleChange":true,"subtitle":"Third page's subtitle"},{"body":"Fourth page's body","subtitle":"Fourth page's subtitle","title":"Fourth page's title"}],"progressBarPayload":"automatic"},"silent":false,"forceLightMode":false,"disableQuit":false,"buttonless":false,"hideTitleBar":false,"miniaturizable":false,"topicID":"untracked","notificationID":"untracked"},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
""" // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(!app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["help_button"].exists)
            app.buttons["main_button"].tap()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["tertiary_button"].exists)
            XCTAssert(app.buttons["help_button"].exists)
            app.buttons["main_button"].tap()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(!app.buttons["secondary_button"].exists)
            app.buttons["main_button"].tap()
            XCTAssert(app.staticTexts["onboarding_title"].exists)
            XCTAssert(app.staticTexts["onboarding_subtitle"].exists)
            XCTAssert(app.staticTexts["onboarding_body"].exists)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(!app.buttons["secondary_button"].exists)
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
}
