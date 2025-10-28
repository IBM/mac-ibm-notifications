//
//  NAPUITests.swift
//  Notification Agent Popup UI Tests
//
//  Created by Simone Martorelli on 02/06/22.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

extension XCTestCase {
    /// Non-blocking wait helper for UI tests to avoid direct `sleep` on the main thread.
    func waitForSeconds(_ seconds: TimeInterval, file: StaticString = #filePath, line: UInt = #line) {
        let expectation = self.expectation(description: "Wait for \(seconds) seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: seconds + 1)
        if result != .completed {
            XCTFail("Wait did not complete in time", file: file, line: line)
        }
    }
}

// swiftlint:disable type_body_length file_length
class NAPUITests: XCTestCase {
    
    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Main Button:  Label --> Ok
    /// BarTitle: Some Title
    /// Icon: "default_icon"
    func testA1Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some Title","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "OK")
            XCTAssertEqual(app.images["popup_icon"].label, "default_icon")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssertEqual(app.windows["main_window"].title, "Some Title")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing simple Pop-up with:
    /// Subtitle: This is a subtitle
    /// BarTitle: IBM Notifier
    /// Main Button:  Label --> Ok
    func testA2Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "OK")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.windows["main_window"].title, "IBM Notifier")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Position: top_left
    /// Main Button:  Label --> Ok
    func testA3Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","position":"top_left","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"IBM Notifier","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "OK")
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Silent: true
    /// Main Button:  Label --> Ok
    func testA4Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":true,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"IBM N otifier","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "OK")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button:  Label --> Primary
    /// Secondary Button:  Label --> Secondary
    func testA5Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"IBM Notifier","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button:  Label --> Primary
    /// Secondary Button:  Label --> Secondary
    /// Tertiary Button: Label --> Tertiary
    func testA6Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"tertiaryButton":{"label":"Tertiary","callToActionType":"link","callToActionPayload":"https://www.google.com"},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"IBM Notifier","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.buttons["tertiary_button"].exists)
            XCTAssertEqual(app.buttons["tertiary_button"].label, "Tertiary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// BarTitle: Some
    func testA7Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssertEqual(app.windows["main_window"].title, "Some")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    func testA8Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssertEqual(app.images["popup_icon"].label, "circle")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: slideshow with 3 images
    func testA9Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"slideshow","payload":"/images https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg\\nhttps://cdn.pixabay.com/photo/2015/04/19/08/32/rose-729509_960_720.jpg\\nhttps://cdn.pixabay.com/photo/2015/07/05/10/18/tree-832079_960_720.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["accessory_view_slideshow_image"].exists)
            XCTAssert(!app.buttons["accessory_view_slideshow_backward_button"].exists)
            XCTAssert(app.buttons["accessory_view_slideshow_forward_button"].exists)
            app.buttons["accessory_view_slideshow_forward_button"].tap()
            XCTAssert(app.buttons["accessory_view_slideshow_forward_button"].exists)
            XCTAssert(app.buttons["accessory_view_slideshow_backward_button"].exists)
            app.buttons["accessory_view_slideshow_forward_button"].tap()
            XCTAssert(app.buttons["accessory_view_slideshow_backward_button"].exists)
            XCTAssert(!app.buttons["accessory_view_slideshow_forward_button"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: image
    func testB1Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["image_accessory_view"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: whitebox
    func testB2Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"whitebox","payload":"Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["secondary_button"].isHittable)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.textViews["markdown_accessory_view"].exists)
            XCTAssertEqual(app.textViews["markdown_accessory_view"].value as? String ?? "", "Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: timer
    func testB3Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false,"accessoryViews":[{"type":"timer","payload":"Time left: %@"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["secondary_button"].isHittable)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["timer_accessory_view"].exists)
            let firstLabel = app.staticTexts["timer_accessory_view"].value as? String ?? ""
            sleep(2)
            let secondLabel = app.staticTexts["timer_accessory_view"].value as? String ?? ""
            XCTAssertNotEqual(firstLabel, secondLabel)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: input
    func testB4Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"input","payload":"/title AV Title /placeholder Some placeholder"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["secondary_button"].isHittable)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.staticTexts["input_accessory_view_title"].value as? String ?? "", "AV Title")
            XCTAssertEqual(app.textFields["input_accessory_view_textfield"].placeholderValue ?? "", "Some placeholder")
            app.textFields["input_accessory_view_textfield"].click()
            app.textFields["input_accessory_view_textfield"].typeText("This is the value")
            XCTAssertEqual(app.textFields["input_accessory_view_textfield"].value as? String ?? "", "This is the value")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: secureinput
    func testB5Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"secureinput","payload":"/title AV Title /placeholder Some secure placeholder"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["secondary_button"].isHittable)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.staticTexts["input_accessory_view_title"].value as? String ?? "", "AV Title")
            XCTAssertEqual(app.secureTextFields["input_accessory_view_secure_textfield"].placeholderValue ?? "", "Some secure placeholder")
            app.secureTextFields["input_accessory_view_secure_textfield"].click()
            app.secureTextFields["input_accessory_view_secure_textfield"].typeText("Pass")
            XCTAssertEqual(app.secureTextFields["input_accessory_view_secure_textfield"].value as? String ?? "", "")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: progressbar
    func testB6Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"progressbar","payload":"/percent 0 /top_message Top /bottom_message Bottom"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssertFalse(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.staticTexts["progressbar_accessory_view_top_message"].value as? String ?? "", "Top")
            XCTAssert(app.progressIndicators["progressbar_accessory_view_progressview_determined"].exists)
            XCTAssertEqual(app.progressIndicators["progressbar_accessory_view_progressview_determined"].value as? CGFloat ?? -1, 0)
            XCTAssertEqual(app.staticTexts["progressbar_accessory_view_bottom_message"].value as? String ?? "", "Bottom")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: progressbar
    func testB7Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"progressbar","payload":"/percent indeterminate /top_message Top /bottom_message Bottom"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssertFalse(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.staticTexts["progressbar_accessory_view_top_message"].value as? String ?? "", "Top")
            XCTAssert(app.activityIndicators["progressbar_accessory_view_progressview_indeterminate"].exists)
            XCTAssertEqual(app.activityIndicators["progressbar_accessory_view_progressview_indeterminate"].value as? CGFloat ?? -1, 0)
            XCTAssertEqual(app.staticTexts["progressbar_accessory_view_bottom_message"].value as? String ?? "", "Bottom")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: progressbar
    func testB8Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"progressbar","payload":"/percent 50 /top_message Top /bottom_message Bottom"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssertFalse(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.staticTexts["progressbar_accessory_view_top_message"].value as? String ?? "", "Top")
            XCTAssert(app.progressIndicators["progressbar_accessory_view_progressview_determined"].exists)
            XCTAssertEqual(app.progressIndicators["progressbar_accessory_view_progressview_determined"].value as? CGFloat ?? -1, 0.5)
            XCTAssertEqual(app.staticTexts["progressbar_accessory_view_bottom_message"].value as? String ?? "", "Bottom")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: dropdown
    func testB9Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"dropdown","payload":"/list First\\nSecond\\nThird /placeholder Pick something /title Some title"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["picker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["picker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].exists)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "Pick something")
            app.popUpButtons["picker_accessory_view_dropdown"].click()
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].menuItems["First"].exists)
            app.popUpButtons["picker_accessory_view_dropdown"].menuItems["First"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "First")
            app.popUpButtons["picker_accessory_view_dropdown"].click()
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].menuItems["Second"].exists)
            app.popUpButtons["picker_accessory_view_dropdown"].menuItems["Second"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "Second")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: dropdown
    func testC1Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"dropdown","payload":"/list First\\nSecond\\nThird /placeholder Pick something"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].exists)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "Pick something")
            app.popUpButtons["picker_accessory_view_dropdown"].click()
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].menuItems["First"].exists)
            app.popUpButtons["picker_accessory_view_dropdown"].menuItems["First"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "First")
            XCTAssert(app.buttons["main_button"].isEnabled)
            app.popUpButtons["picker_accessory_view_dropdown"].click()
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].menuItems["Pick something"].exists)
            app.popUpButtons["picker_accessory_view_dropdown"].menuItems["Pick something"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "Pick something")
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist
    func testC2Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /title Some title"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["picker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["picker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.checkBoxes["picker_accessory_view_checkboxes_First"].exists)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].label, "First")
            app.checkBoxes["picker_accessory_view_checkboxes_First"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].value as? Bool, true)
            XCTAssert(app.checkBoxes["picker_accessory_view_checkboxes_Second"].exists)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_Second"].label, "Second")
            app.checkBoxes["picker_accessory_view_checkboxes_Second"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_Second"].value as? Bool, true)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist
    func testC3Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /required"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.checkBoxes["picker_accessory_view_checkboxes_First"].exists)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].label, "First")
            app.checkBoxes["picker_accessory_view_checkboxes_First"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].value as? Bool, true)
            XCTAssert(app.buttons["main_button"].isEnabled)
            app.checkBoxes["picker_accessory_view_checkboxes_First"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].value as? Bool, false)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist
    func testC4Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /complete"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.checkBoxes["picker_accessory_view_checkboxes_First"].exists)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].label, "First")
            app.checkBoxes["picker_accessory_view_checkboxes_First"].click()
            waitForSeconds(1)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            app.checkBoxes["picker_accessory_view_checkboxes_Second"].click()
            app.checkBoxes["picker_accessory_view_checkboxes_Third"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_First"].value as? Bool, true)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_Second"].value as? Bool, true)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_Third"].value as? Bool, true)
            XCTAssert(app.buttons["main_button"].isEnabled)
            app.checkBoxes["picker_accessory_view_checkboxes_First"].click()
            waitForSeconds(1)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist
    func testC5Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /preselection 1 /required"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.checkBoxes["picker_accessory_view_checkboxes_Second"].exists)
            XCTAssertEqual(app.checkBoxes["picker_accessory_view_checkboxes_Second"].label, "Second")
            app.checkBoxes["picker_accessory_view_checkboxes_Second"].click()
            waitForSeconds(1)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            app.checkBoxes["picker_accessory_view_checkboxes_Second"].click()
            waitForSeconds(1)
            XCTAssert(app.buttons["main_button"].isEnabled)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist - radio
    func testC6Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /radio /required /title Some title"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertFalse(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["picker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["picker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["First"].exists)
            app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["First"].click()
            waitForSeconds(1)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["First"].isSelected)
            XCTAssert(app.buttons["main_button"].isEnabled)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist - radio
    func testC7Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /radio"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["First"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["Second"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["Third"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: checklist - radio
    func testC8Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"checklist","payload":"/list First\\nSecond\\nThird /radio /preselection 1"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["First"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["Second"].exists)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["Second"].isSelected)
            XCTAssert(app.radioGroups["picker_accessory_view_radio_buttons"].radioButtons["Third"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: datepicker
    func testC9Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"datepicker","payload":"/title Some title"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["datepicker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["datepicker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].exists)
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].isEnabled)
            XCTAssertNotNil(app.datePickers["datepicker_accessory_view_picker"].value)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: datepicker
    func testD1Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"datepicker","payload":"/title Some title /style graphical"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["datepicker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["datepicker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].exists)
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].isHittable)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: datepicker
    func testD2Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"datepicker","payload":"/title Some title /style graphical /components date"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.staticTexts["datepicker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["datepicker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].exists)
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].isHittable)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Custom Width:  1000
    /// AccessoryView: whitebox
    func testD3Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","customWidth":"1000","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"whitebox","payload":"Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.buttons["secondary_button"].isHittable)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.textViews["markdown_accessory_view"].exists)
            XCTAssertEqual(app.textViews["markdown_accessory_view"].value as? String ?? "", "Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Unmovable: true
    func testD4Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":false,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.windows["main_window"].exists)
            XCTAssert(app.windows["main_window"].isHittable)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            let initialPositionY = app.windows["main_window"].frame.minY
            let initialPositionX = app.windows["main_window"].frame.minX
            let coordinate = app.windows["main_window"].coordinate(withNormalizedOffset: CGVector(dx: 0.02, dy: 0.04))
            coordinate.click(forDuration: 1, thenDragTo: app.buttons["main_button"].coordinate(withNormalizedOffset: .zero))
            let finalPositionY = app.windows["main_window"].frame.minY
            let finalPositionX = app.windows["main_window"].frame.minX
            XCTAssert(initialPositionX == finalPositionX)
            XCTAssert(initialPositionY == finalPositionY)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Unmovable: false
    func testD5Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"timeout":"30","barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.windows["main_window"].exists)
            XCTAssert(app.windows["main_window"].isHittable)
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssert(app.buttons["main_button"].isEnabled)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            let initialPositionY = app.windows["main_window"].frame.minY
            let initialPositionX = app.windows["main_window"].frame.minX
            let coordinate = app.windows["main_window"].coordinate(withNormalizedOffset: CGVector(dx: 0.02, dy: 0.04))
            coordinate.click(forDuration: 1, thenDragTo: app.buttons["main_button"].coordinate(withNormalizedOffset: .zero))
            let finalPositionY = app.windows["main_window"].frame.minY
            let finalPositionX = app.windows["main_window"].frame.minX
            XCTAssertFalse(initialPositionX == finalPositionX)
            XCTAssertFalse(initialPositionY == finalPositionY)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// BarTitle: Some Title
    /// Buttonless: true
    func testD6Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some Title","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":true,"hideTitleBar":false},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            
            XCTAssertFalse(app.buttons["main_button"].exists)
            XCTAssertEqual(app.images["popup_icon"].label, "default_icon")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssertEqual(app.windows["main_window"].title, "Some Title")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: image with a GIF
    func testD7Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["image_accessory_view"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: image with a GIF
    /// Secondary AccessoryView: image
    func testD8Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"},{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["image_accessory_view"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Main Button:  Label --> Ok
    /// BarTitle: hidden
    /// Icon: "default_icon"
    func testD9Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"OK","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"accessoryViews":[],"alwaysOnTop":false,"type":"popup","title":"This is a title","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some Title","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":true},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "OK")
            XCTAssertEqual(app.images["popup_icon"].label, "default_icon")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssertEqual(app.windows["main_window"].title, "")
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// AccessoryView: dropdown
    /// AccessoryView1: datepicker
    /// AccessoryView2: whitebox
    /// AccessoryView3: GIF
    /// AccessoryView4: image
    func testE1Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"dropdown","payload":"/list First\\nSecond\\nThird /placeholder Pick something /title Some title"},{"type":"datepicker","payload":"/title Some title /style graphical /components date"},{"type":"whitebox","payload":"Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view"},{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"},{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssertEqual(app.staticTexts["picker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].exists)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "Pick something")
            app.popUpButtons["picker_accessory_view_dropdown"].click()
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].menuItems["First"].exists)
            app.popUpButtons["picker_accessory_view_dropdown"].menuItems["First"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "First")
            app.popUpButtons["picker_accessory_view_dropdown"].click()
            XCTAssert(app.popUpButtons["picker_accessory_view_dropdown"].menuItems["Second"].exists)
            app.popUpButtons["picker_accessory_view_dropdown"].menuItems["Second"].click()
            waitForSeconds(1)
            XCTAssertEqual(app.popUpButtons["picker_accessory_view_dropdown"].value as? String, "Second")
            XCTAssert(app.staticTexts["datepicker_accessory_view_title"].exists)
            XCTAssertEqual(app.staticTexts["datepicker_accessory_view_title"].value as? String ?? "", "Some title")
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].exists)
            XCTAssert(app.datePickers["datepicker_accessory_view_picker"].isEnabled)
            XCTAssertNotNil(app.datePickers["datepicker_accessory_view_picker"].value)
            XCTAssert(app.textViews["markdown_accessory_view"].exists)
            XCTAssertEqual(app.textViews["markdown_accessory_view"].value as? String ?? "", "Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view Some text in the whitebox accessory view")
            XCTAssert(app.images["image_accessory_view"].exists)
            XCTAssert(app.staticTexts["picker_accessory_view_title"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: image with a GIF
    /// Secondary AccessoryView: image
    /// Position: bottom right
    func testE2Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"position":"bottom_right","showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"},{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["image_accessory_view"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: image with a GIF
    /// Secondary AccessoryView: image
    /// Position: top right
    func testE3Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"position":"top_right","showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"},{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["image_accessory_view"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    /// AccessoryView: image with a GIF
    /// Secondary AccessoryView: image
    /// Position: bottom left
    func testE4Popup() throws {
        let useCase = """
        {"notification":{"topicID":"untracked","mainButton":{"label":"Primary","callToActionType":"none","callToActionPayload":""},"secondaryButton":{"label":"Secondary","callToActionType":"none","callToActionPayload":""},"iconPath":"circle","hideTitleBarButtons":false,"retainValues":false,"alwaysOnTop":false,"type":"popup","title":"This is a title","subtitle":"This is a subtitle","silent":false,"position":"bottom_left","showSuppressionButton":false,"miniaturizable":false,"barTitle":"Some","forceLightMode":false,"notificationID":"untracked","isMovable":true,"disableQuit":false,"buttonless":false,"hideTitleBar":false, "accessoryViews":[{"type":"image","payload":"https://compote.slate.com/images/697b023b-64a5-49a0-8059-27b963453fb1.gif?crop=780%2C520%2Cx0%2Cy0&width=2200"},{"type":"image","payload":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"}]},"settings":{"isVerboseModeEnabled":false,"environment":"prod"}}
        """ // pragma: allowlist-secret
        if let useCaseData = useCase.data(using: .utf8) {
            let app = XCUIApplication()
            app.launchArguments = [useCaseData.base64EncodedString()]
            app.launch()
            XCTAssert(app.buttons["main_button"].exists)
            XCTAssertEqual(app.buttons["main_button"].title, "Primary")
            XCTAssert(app.buttons["main_button"].isHittable)
            XCTAssert(app.buttons["secondary_button"].exists)
            XCTAssertEqual(app.buttons["secondary_button"].label, "Secondary")
            XCTAssert(app.staticTexts["popup_title"].exists)
            XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
            XCTAssert(app.staticTexts["popup_subtitle"].exists)
            XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
            XCTAssert(app.images["image_accessory_view"].exists)
            app.terminate()
        } else {
            XCTAssert(false, "Failed to encode the usecase.")
        }
    }
}
// swiftlint:enable type_body_length file_length
