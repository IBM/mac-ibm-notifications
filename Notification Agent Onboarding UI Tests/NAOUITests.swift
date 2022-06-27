//
//  NAOUITests.swift
//  Notification Agent Onboarding UI Tests
//
//  Created by Simone Martorelli on 08/06/22.
//  Copyright © 2022 IBM. All rights reserved.
//

import XCTest

class NAOUITests: XCTestCase {

    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Main Button: Ok
    func test1Onboarding() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJub3RpZmljYXRpb25JRCI6InVudHJhY2tlZCIsInJldGFpblZhbHVlcyI6ZmFsc2UsImFjY2Vzc29yeVZpZXdzIjpbXSwicGF5bG9hZCI6eyJwYWdlcyI6W3siYm9keSI6IlNvbWUgYm9keSIsInRpdGxlIjoiVGhpcyBpcyBhIHRpdGxlIiwic3VidGl0bGUiOiJUaGlzIGlzIGEgc3VidGl0bGUiLCJhY2Nlc3NvcnlWaWV3cyI6W1t7InR5cGUiOiJpbnB1dCIsInBheWxvYWQiOiJcL3BsYWNlaG9sZGVyIFNvbWUgXC90aXRsZSBGaXJzdCJ9LHsidHlwZSI6ImlucHV0IiwicGF5bG9hZCI6IlwvcGxhY2Vob2xkZXIgU29tZSBcL3RpdGxlIFNlY29uZCJ9XV19LHsiYm9keSI6IlNvbWUgYm9keSIsInRpdGxlIjoiVGhpcyBpcyBhIHRpdGxlIiwic3VidGl0bGUiOiJUaGlzIGlzIGEgc3VidGl0bGUiLCJhY2Nlc3NvcnlWaWV3cyI6W1t7InR5cGUiOiJpbnB1dCIsInBheWxvYWQiOiJcL3BsYWNlaG9sZGVyIFNvbWUgXC90aXRsZSBGaXJzdCJ9LHsidHlwZSI6ImlucHV0IiwicGF5bG9hZCI6IlwvcGxhY2Vob2xkZXIgU29tZSBcL3RpdGxlIFNlY29uZCJ9XV19XX0sImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6Im9uYm9hcmRpbmciLCJzaWxlbnQiOmZhbHNlLCJtaW5pYXR1cml6YWJsZSI6ZmFsc2UsImJhclRpdGxlIjoiTWFjQElCTSBOb3RpZmljYXRpb25zIiwiZm9yY2VMaWdodE1vZGUiOmZhbHNlLCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZX0sInNldHRpbmdzIjp7ImVudmlyb25tZW50IjoicHJvZCIsImlzUmVzdENsaWVudEVuYWJsZWQiOmZhbHNlLCJpc0FuYWx5dGljc0VuYWJsZWQiOmZhbHNlLCJpc1ZlcmJvc2VNb2RlRW5hYmxlZCI6ZmFsc2V9fQ==" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["onboarding_accessibility_button_right"].exists)
        app.buttons["onboarding_accessibility_button_right"].tap()
        XCTAssert(app.buttons["onboarding_accessibility_button_right"].exists)
        XCTAssert(app.buttons["onboarding_accessibility_button_left"].exists)
    }
}
