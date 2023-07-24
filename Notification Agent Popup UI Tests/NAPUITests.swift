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
    /// Main Button:  Label --> Ok
    /// BarTitle: Some Title
    /// Icon: "default_icon"
    func test1Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwidGl0bGUiOiJUaGlzIGlzIGEgdGl0bGUiLCJzaWxlbnQiOmZhbHNlLCJzaG93U3VwcHJlc3Npb25CdXR0b24iOmZhbHNlLCJtaW5pYXR1cml6YWJsZSI6ZmFsc2UsImJhclRpdGxlIjoiU29tZSBUaXRsZSIsImZvcmNlTGlnaHRNb2RlIjpmYWxzZSwibm90aWZpY2F0aW9uSUQiOiJ1bnRyYWNrZWQifSwic2V0dGluZ3MiOnsiaXNWZXJib3NlTW9kZUVuYWJsZWQiOmZhbHNlLCJlbnZpcm9ubWVudCI6InByb2QifX0=" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssertEqual(app.images["popup_icon"].label, "default_icon")
        XCTAssert(app.staticTexts["popup_title"].exists)
        XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
        XCTAssertEqual(app.windows["main_window"].title, "Some Title")
        app.terminate()
    }
    
    /// Testing simple Pop-up with:
    /// Subtitle: This is a subtitle
    /// BarTitle: IBM Notifier
    /// Main Button:  Label --> Ok
    func test2Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwic3VidGl0bGUiOiJUaGlzIGlzIGEgc3VidGl0bGUiLCJzaWxlbnQiOmZhbHNlLCJzaG93U3VwcHJlc3Npb25CdXR0b24iOmZhbHNlLCJtaW5pYXR1cml6YWJsZSI6ZmFsc2UsImZvcmNlTGlnaHRNb2RlIjpmYWxzZSwibm90aWZpY2F0aW9uSUQiOiJ1bnRyYWNrZWQifSwic2V0dGluZ3MiOnsiaXNWZXJib3NlTW9kZUVuYWJsZWQiOmZhbHNlLCJlbnZpcm9ubWVudCI6InByb2QifX0=" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.staticTexts["popup_subtitle"].exists)
        XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
        XCTAssertEqual(app.windows["main_window"].title, "IBM Notifier")
        app.terminate()
    }
    
    /// Testing simple Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Position: top_left
    /// Main Button:  Label --> Ok
    func test3Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwidGl0bGUiOiJUaGlzIGlzIGEgdGl0bGUiLCJwb3NpdGlvbiI6InRvcF9sZWZ0Iiwic3VidGl0bGUiOiJUaGlzIGlzIGEgc3VidGl0bGUiLCJzaWxlbnQiOmZhbHNlLCJzaG93U3VwcHJlc3Npb25CdXR0b24iOmZhbHNlLCJtaW5pYXR1cml6YWJsZSI6ZmFsc2UsImJhclRpdGxlIjoiTWFjQElCTSBOb3RpZmljYXRpb25zIiwiZm9yY2VMaWdodE1vZGUiOmZhbHNlLCJub3RpZmljYXRpb25JRCI6InVudHJhY2tlZCJ9LCJzZXR0aW5ncyI6eyJpc1ZlcmJvc2VNb2RlRW5hYmxlZCI6ZmFsc2UsImVudmlyb25tZW50IjoicHJvZCJ9fQ==" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.staticTexts["popup_title"].exists)
        XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
        XCTAssert(app.staticTexts["popup_subtitle"].exists)
        XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
        app.terminate()
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Silent: true
    /// Main Button:  Label --> Ok
    func test4Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJPSyIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwidGl0bGUiOiJUaGlzIGlzIGEgdGl0bGUiLCJzdWJ0aXRsZSI6IlRoaXMgaXMgYSBzdWJ0aXRsZSIsInNpbGVudCI6dHJ1ZSwic2hvd1N1cHByZXNzaW9uQnV0dG9uIjpmYWxzZSwibWluaWF0dXJpemFibGUiOmZhbHNlLCJiYXJUaXRsZSI6Ik1hY0BJQk0gTm90aWZpY2F0aW9ucyIsImZvcmNlTGlnaHRNb2RlIjpmYWxzZSwibm90aWZpY2F0aW9uSUQiOiJ1bnRyYWNrZWQifSwic2V0dGluZ3MiOnsiaXNWZXJib3NlTW9kZUVuYWJsZWQiOmZhbHNlLCJlbnZpcm9ubWVudCI6InByb2QifX0=" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
        app.launch()
        XCTAssert(app.buttons["main_button"].exists)
        XCTAssertEqual(app.buttons["main_button"].title, "OK")
        XCTAssert(app.staticTexts["popup_title"].exists)
        XCTAssertEqual(app.staticTexts["popup_title"].value as? String ?? "", "This is a title")
        XCTAssert(app.staticTexts["popup_subtitle"].exists)
        XCTAssertEqual(app.staticTexts["popup_subtitle"].value as? String ?? "", "This is a subtitle")
        app.terminate()
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button:  Label --> Primary
    /// Secondary Button:  Label --> Secondary
    func test5Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJQcmltYXJ5IiwiY2FsbFRvQWN0aW9uVHlwZSI6Im5vbmUiLCJjYWxsVG9BY3Rpb25QYXlsb2FkIjoiIn0sInNlY29uZGFyeUJ1dHRvbiI6eyJsYWJlbCI6IlNlY29uZGFyeSIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwidGl0bGUiOiJUaGlzIGlzIGEgdGl0bGUiLCJzdWJ0aXRsZSI6IlRoaXMgaXMgYSBzdWJ0aXRsZSIsInNpbGVudCI6ZmFsc2UsInNob3dTdXBwcmVzc2lvbkJ1dHRvbiI6ZmFsc2UsIm1pbmlhdHVyaXphYmxlIjpmYWxzZSwiYmFyVGl0bGUiOiJNYWNASUJNIE5vdGlmaWNhdGlvbnMiLCJmb3JjZUxpZ2h0TW9kZSI6ZmFsc2UsIm5vdGlmaWNhdGlvbklEIjoidW50cmFja2VkIn0sInNldHRpbmdzIjp7ImlzVmVyYm9zZU1vZGVFbmFibGVkIjpmYWxzZSwiZW52aXJvbm1lbnQiOiJwcm9kIn19" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
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
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button:  Label --> Primary
    /// Secondary Button:  Label --> Secondary
    /// Tertiary Button: Label --> Tertiary
    func test6Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJQcmltYXJ5IiwiY2FsbFRvQWN0aW9uVHlwZSI6Im5vbmUiLCJjYWxsVG9BY3Rpb25QYXlsb2FkIjoiIn0sInNlY29uZGFyeUJ1dHRvbiI6eyJsYWJlbCI6IlNlY29uZGFyeSIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJ0ZXJ0aWFyeUJ1dHRvbiI6eyJsYWJlbCI6IlRlcnRpYXJ5IiwiY2FsbFRvQWN0aW9uVHlwZSI6ImxpbmsiLCJjYWxsVG9BY3Rpb25QYXlsb2FkIjoiaHR0cHM6Ly93d3cuZ29vZ2xlLmNvbSJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwidGl0bGUiOiJUaGlzIGlzIGEgdGl0bGUiLCJzdWJ0aXRsZSI6IlRoaXMgaXMgYSBzdWJ0aXRsZSIsInNpbGVudCI6ZmFsc2UsInNob3dTdXBwcmVzc2lvbkJ1dHRvbiI6ZmFsc2UsIm1pbmlhdHVyaXphYmxlIjpmYWxzZSwiYmFyVGl0bGUiOiJNYWNASUJNIE5vdGlmaWNhdGlvbnMiLCJmb3JjZUxpZ2h0TW9kZSI6ZmFsc2UsIm5vdGlmaWNhdGlvbklEIjoidW50cmFja2VkIn0sInNldHRpbmdzIjp7ImlzVmVyYm9zZU1vZGVFbmFibGVkIjpmYWxzZSwiZW52aXJvbm1lbnQiOiJwcm9kIn19" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
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
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// BarTitle: Some
    func test7Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJQcmltYXJ5IiwiY2FsbFRvQWN0aW9uVHlwZSI6Im5vbmUiLCJjYWxsVG9BY3Rpb25QYXlsb2FkIjoiIn0sInNlY29uZGFyeUJ1dHRvbiI6eyJsYWJlbCI6IlNlY29uZGFyeSIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJoaWRlVGl0bGVCYXJCdXR0b25zIjpmYWxzZSwicmV0YWluVmFsdWVzIjpmYWxzZSwiYWNjZXNzb3J5Vmlld3MiOltdLCJpc01vdmFibGUiOnRydWUsImFsd2F5c09uVG9wIjpmYWxzZSwidHlwZSI6InBvcHVwIiwidGl0bGUiOiJUaGlzIGlzIGEgdGl0bGUiLCJzdWJ0aXRsZSI6IlRoaXMgaXMgYSBzdWJ0aXRsZSIsInNpbGVudCI6ZmFsc2UsInNob3dTdXBwcmVzc2lvbkJ1dHRvbiI6ZmFsc2UsIm1pbmlhdHVyaXphYmxlIjpmYWxzZSwiYmFyVGl0bGUiOiJTb21lIiwiZm9yY2VMaWdodE1vZGUiOmZhbHNlLCJub3RpZmljYXRpb25JRCI6InVudHJhY2tlZCJ9LCJzZXR0aW5ncyI6eyJpc1ZlcmJvc2VNb2RlRW5hYmxlZCI6ZmFsc2UsImVudmlyb25tZW50IjoicHJvZCJ9fQ==" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
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
    }
    
    /// Testing Pop-up with:
    /// Title: This is a title
    /// Subtitle: This is a subtitle
    /// Main Button: Primary
    /// Secondary Button: Secondary
    /// Icon: Circle SFSymbol
    func test8Popup() throws {
        let useCase = "eyJub3RpZmljYXRpb24iOnsidG9waWNJRCI6InVudHJhY2tlZCIsIm1haW5CdXR0b24iOnsibGFiZWwiOiJQcmltYXJ5IiwiY2FsbFRvQWN0aW9uVHlwZSI6Im5vbmUiLCJjYWxsVG9BY3Rpb25QYXlsb2FkIjoiIn0sInNlY29uZGFyeUJ1dHRvbiI6eyJsYWJlbCI6IlNlY29uZGFyeSIsImNhbGxUb0FjdGlvblR5cGUiOiJub25lIiwiY2FsbFRvQWN0aW9uUGF5bG9hZCI6IiJ9LCJpY29uUGF0aCI6ImNpcmNsZSIsImhpZGVUaXRsZUJhckJ1dHRvbnMiOmZhbHNlLCJyZXRhaW5WYWx1ZXMiOmZhbHNlLCJhY2Nlc3NvcnlWaWV3cyI6W10sImlzTW92YWJsZSI6dHJ1ZSwiYWx3YXlzT25Ub3AiOmZhbHNlLCJ0eXBlIjoicG9wdXAiLCJ0aXRsZSI6IlRoaXMgaXMgYSB0aXRsZSIsInN1YnRpdGxlIjoiVGhpcyBpcyBhIHN1YnRpdGxlIiwic2lsZW50IjpmYWxzZSwic2hvd1N1cHByZXNzaW9uQnV0dG9uIjpmYWxzZSwibWluaWF0dXJpemFibGUiOmZhbHNlLCJiYXJUaXRsZSI6IlNvbWUiLCJmb3JjZUxpZ2h0TW9kZSI6ZmFsc2UsIm5vdGlmaWNhdGlvbklEIjoidW50cmFja2VkIn0sInNldHRpbmdzIjp7ImlzVmVyYm9zZU1vZGVFbmFibGVkIjpmYWxzZSwiZW52aXJvbm1lbnQiOiJwcm9kIn19" // pragma: allowlist-secret
        let app = XCUIApplication()
        app.launchArguments = [useCase]
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
    }
}
