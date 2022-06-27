//
//  NAPUITests.swift
//  Notification Agent Popup UI Tests
//
//  Created by Simone Martorelli on 02/06/22.
//  Copyright © 2022 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import XCTest

class NAPUITests: XCTestCase {
    
    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Main Button: Ok
    func test1Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJhbHdheXNPblRvcCI6ZmFsc2UsInR5cGUiOiJwb3B1cCIsInRpdGxlIjoiVGhpcyBpcyBhIHRpdGxlIiwic2lsZW50IjpmYWxzZSwibWluaWF0dXJpemFibGUiOmZhbHNlLCJiYXJUaXRsZSI6Ik1hY0BJQk0gTm90aWZpY2F0aW9ucyIsImZvcmNlTGlnaHRNb2RlIjpmYWxzZSwibm90aWZpY2F0aW9uSUQiOiJ1bnRyYWNrZWQifSwic2V0dGluZ3MiOnsiZW52aXJvbm1lbnQiOiJwcm9kIiwiaXNSZXN0Q2xpZW50RW5hYmxlZCI6ZmFsc2UsImlzQW5hbHl0aWNzRW5hYmxlZCI6ZmFsc2UsImlzVmVyYm9zZU1vZGVFbmFibGVkIjpmYWxzZX19" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.otherElements["title_textfield"].exists)
        XCTAssertEqual(app.otherElements["title_textfield"].value as? String ?? "", "This is a title")
        app.terminate()
    }
    
    /// Testing simple Pop-up with:
    /// Subtitle: This is a subtitle
    /// Main Button: Ok
    func test2Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJub3RpZmljYXRpb25JRCI6InVudHJhY2tlZCIsInN1YnRpdGxlIjoiVGhpcyBpcyBhIHN1YnRpdGxlIiwiYWNjZXNzb3J5Vmlld3MiOltdLCJyZXRhaW5WYWx1ZXMiOmZhbHNlLCJhbHdheXNPblRvcCI6ZmFsc2UsInR5cGUiOiJwb3B1cCIsInNpbGVudCI6ZmFsc2UsIm1pbmlhdHVyaXphYmxlIjpmYWxzZSwiYmFyVGl0bGUiOiJNYWNASUJNIE5vdGlmaWNhdGlvbnMiLCJmb3JjZUxpZ2h0TW9kZSI6ZmFsc2UsImhpZGVUaXRsZUJhckJ1dHRvbnMiOmZhbHNlfSwic2V0dGluZ3MiOnsiZW52aXJvbm1lbnQiOiJwcm9kIiwiaXNSZXN0Q2xpZW50RW5hYmxlZCI6ZmFsc2UsImlzQW5hbHl0aWNzRW5hYmxlZCI6ZmFsc2UsImlzVmVyYm9zZU1vZGVFbmFibGVkIjpmYWxzZX19" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.textViews["accessory_view_accessibility_markdown_textview"].exists)
        XCTAssertEqual(app.textViews["accessory_view_accessibility_markdown_textview"].value as? String ?? "", "This is a subtitle")
        app.terminate()
    }
    
    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Position: top_left
    /// Main Button: Ok
    func test3Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJmb3JjZUxpZ2h0TW9kZSI6ZmFsc2UsInN1YnRpdGxlIjoiVGhpcyBpcyBhIHN1YnRpdGxlIiwiYWNjZXNzb3J5Vmlld3MiOltdLCJyZXRhaW5WYWx1ZXMiOmZhbHNlLCJwb3NpdGlvbiI6InRvcF9sZWZ0IiwiYWx3YXlzT25Ub3AiOmZhbHNlLCJ0eXBlIjoicG9wdXAiLCJ0aXRsZSI6IlRoaXMgaXMgYSB0aXRsZSIsInNpbGVudCI6ZmFsc2UsIm1pbmlhdHVyaXphYmxlIjpmYWxzZSwiYmFyVGl0bGUiOiJNYWNASUJNIE5vdGlmaWNhdGlvbnMiLCJub3RpZmljYXRpb25JRCI6InVudHJhY2tlZCIsImhpZGVUaXRsZUJhckJ1dHRvbnMiOmZhbHNlfSwic2V0dGluZ3MiOnsiZW52aXJvbm1lbnQiOiJwcm9kIiwiaXNSZXN0Q2xpZW50RW5hYmxlZCI6ZmFsc2UsImlzQW5hbHl0aWNzRW5hYmxlZCI6ZmFsc2UsImlzVmVyYm9zZU1vZGVFbmFibGVkIjpmYWxzZX19" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.otherElements["title_textfield"].exists)
        XCTAssertEqual(app.otherElements["title_textfield"].value as? String ?? "", "This is a title")
        XCTAssert(app.textViews["accessory_view_accessibility_markdown_textview"].exists)
        XCTAssertEqual(app.textViews["accessory_view_accessibility_markdown_textview"].value as? String ?? "", "This is a subtitle")
        app.terminate()
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Silent: true
    /// Main Button: Ok
    func test4Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJmb3JjZUxpZ2h0TW9kZSI6ZmFsc2UsInN1YnRpdGxlIjoiVGhpcyBpcyBhIHN1YnRpdGxlIiwiYWNjZXNzb3J5Vmlld3MiOltdLCJyZXRhaW5WYWx1ZXMiOmZhbHNlLCJhbHdheXNPblRvcCI6ZmFsc2UsInR5cGUiOiJwb3B1cCIsInRpdGxlIjoiVGhpcyBpcyBhIHRpdGxlIiwic2lsZW50Ijp0cnVlLCJtaW5pYXR1cml6YWJsZSI6ZmFsc2UsImJhclRpdGxlIjoiTWFjQElCTSBOb3RpZmljYXRpb25zIiwibm90aWZpY2F0aW9uSUQiOiJ1bnRyYWNrZWQiLCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZX0sInNldHRpbmdzIjp7ImVudmlyb25tZW50IjoicHJvZCIsImlzUmVzdENsaWVudEVuYWJsZWQiOmZhbHNlLCJpc0FuYWx5dGljc0VuYWJsZWQiOmZhbHNlLCJpc1ZlcmJvc2VNb2RlRW5hYmxlZCI6ZmFsc2V9fQ==" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.otherElements["title_textfield"].exists)
        XCTAssertEqual(app.otherElements["title_textfield"].value as? String ?? "", "This is a title")
        XCTAssert(app.textViews["accessory_view_accessibility_markdown_textview"].exists)
        XCTAssertEqual(app.textViews["accessory_view_accessibility_markdown_textview"].value as? String ?? "", "This is a subtitle")
        app.terminate()
    }
}
