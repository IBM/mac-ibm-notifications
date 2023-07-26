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
    func test1Onboarding() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJub3RpZmljYXRpb25JRCI6InVudHJhY2tlZCIsInJldGFpblZhbHVlcyI6ZmFsc2UsImFjY2Vzc29yeVZpZXdzIjpbXSwicGF5bG9hZCI6eyJwYWdlcyI6W3siYm9keSI6IkZpcnN0IHBhZ2UncyBib2R5IiwidG9wSWNvbiI6InNxdWFyZS5hbmQuYXJyb3cudXAiLCJ0aXRsZSI6IkZpcnN0IHBhZ2UncyB0aXRsZSIsInN1YnRpdGxlIjoiRmlyc3QgcGFnZSdzIHN1YnRpdGxlIiwiaW5mb1NlY3Rpb24iOnsiZmllbGRzIjpbeyJpZCI6IlNvbWUgRGVzY3JpcHRpb24gU29tZSIsImxhYmVsIjoiU29tZSBEZXNjcmlwdGlvbiBTb21lIn0seyJpZCI6IlNvbWUgRGVzY3JpcHRpb24gU29tZSIsImxhYmVsIjoiU29tZSBEZXNjcmlwdGlvbiBTb21lIn0seyJpZCI6IlNvbWUgRGVzY3JpcHRpb24gU29tZSIsImxhYmVsIjoiU29tZSBEZXNjcmlwdGlvbiBTb21lIn1dfX0seyJzdWJ0aXRsZSI6IlNlY29uZCBwYWdlJ3Mgc3VidGl0bGUiLCJzaW5nbGVDaGFuZ2UiOnRydWUsInByaW1hcnlCdXR0b25MYWJlbCI6IlNvbWUiLCJ0aXRsZSI6IlNlY29uZCBwYWdlJ3MgdGl0bGUiLCJ0ZXJ0aWFyeUJ1dHRvbiI6eyJsYWJlbCI6IlRlcnRpYXJ5IiwiY2FsbFRvQWN0aW9uVHlwZSI6ImxpbmsiLCJjYWxsVG9BY3Rpb25QYXlsb2FkIjoiaHR0cHM6XC9cL3d3dy5nb29nbGUuY29tIn0sImluZm9TZWN0aW9uIjp7ImZpZWxkcyI6W3siaWQiOiJGaXJzdCBsYWJlbCBvbmx5IiwibGFiZWwiOiJGaXJzdCBsYWJlbCBvbmx5In0seyJpZCI6IlNlY29uZCBsYWJlbCBvbmx5IiwibGFiZWwiOiJTZWNvbmQgbGFiZWwgb25seSJ9LHsiaWQiOiJUaGlyZCBsYWJlbCBvbmx5IiwibGFiZWwiOiJUaGlyZCBsYWJlbCBvbmx5In1dfSwiYm9keSI6IlNlY29uZCBwYWdlJ3MgYm9keSJ9LHsiYm9keSI6IlRoaXJkIHBhZ2UncyBib2R5IiwidGl0bGUiOiJUaGlyZCBwYWdlJ3MgdGl0bGUiLCJzdWJ0aXRsZSI6IlRoaXJkIHBhZ2UncyBzdWJ0aXRsZSIsInNpbmdsZUNoYW5nZSI6dHJ1ZX0seyJ0aXRsZSI6IkZvdXJ0aCBwYWdlJ3MgdGl0bGUiLCJzdWJ0aXRsZSI6IkZvdXJ0aCBwYWdlJ3Mgc3VidGl0bGUiLCJib2R5IjoiRm91cnRoIHBhZ2UncyBib2R5In1dLCJwcm9ncmVzc0JhclBheWxvYWQiOiJhdXRvbWF0aWMifSwiaXNNb3ZhYmxlIjp0cnVlLCJhbHdheXNPblRvcCI6ZmFsc2UsInR5cGUiOiJvbmJvYXJkaW5nIiwic2lsZW50IjpmYWxzZSwic2hvd1N1cHByZXNzaW9uQnV0dG9uIjpmYWxzZSwibWluaWF0dXJpemFibGUiOmZhbHNlLCJiYXJUaXRsZSI6Ik1hY0BJQk0gTm90aWZpY2F0aW9ucyIsImZvcmNlTGlnaHRNb2RlIjpmYWxzZSwiaGlkZVRpdGxlQmFyQnV0dG9ucyI6ZmFsc2V9LCJzZXR0aW5ncyI6eyJpc1ZlcmJvc2VNb2RlRW5hYmxlZCI6ZmFsc2UsImVudmlyb25tZW50IjoicHJvZCJ9fQ==" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
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
    }
}
