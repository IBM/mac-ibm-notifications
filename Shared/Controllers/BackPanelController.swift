//
//  BackPanelController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 23/05/2023.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import AppKit

/// BackPanelController handle the background panel appearance.
/// It detects screen seetting changes and react to provide a better UX.
final class BackPanelController {
    
    // MARK: - Variables
    
    private var backWindows: [BackPanelWindow]
    private var backgroundPanelStyle: NotificationObject.BackgroundPanelStyle
    
    // MARK: - Initializers
    
    init(_ backgroundPanelStyle: NotificationObject.BackgroundPanelStyle) {
        self.backWindows = []
        self.backgroundPanelStyle = backgroundPanelStyle
        NotificationCenter.default.addObserver(self, selector: #selector(screenSettingsDidChange), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    
    // MARK: - Public Methods
    
    /// Shows the background panels on all displays and spaces.
    func showBackgroundWindows() {
        for screen in NSScreen.screens {
            let backWindow = BackPanelWindow(screen, backgroundPanelStyle)
            backWindow.level = .init(Int(CGWindowLevelForKey(.maximumWindow) + 1))
            backWindow.makeKeyAndOrderFront(nil)
            backWindows.append(backWindow)
        }
    }
    
    // MARK: - Private Methods
    
    @objc
    private func screenSettingsDidChange() {
        var newWindows: [BackPanelWindow] = []
        for screen in NSScreen.screens {
            guard backWindows.map({ $0.screen }).contains(where: { $0 == screen }) else {
                let backWindow = BackPanelWindow(screen, backgroundPanelStyle)
                backWindow.level = .init(Int(CGWindowLevelForKey(.maximumWindow) + 1))
                backWindow.makeKeyAndOrderFront(nil)
                newWindows.append(backWindow)
                continue
            }
        }
        backWindows.append(contentsOf: newWindows)
    }
}
