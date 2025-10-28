//
//  BackPanelWindow.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 19/05/2023.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import AppKit

/// BackPanelWindow window provide a fullscreen background panel for the UI if needed.
final class BackPanelWindow: NSWindow {
    
    // MARK: - Initializers
    
    convenience init(_ target: NSScreen, _ customWindowStyle: NotificationObject.BackgroundPanelStyle) {
        self.init(contentRect: NSRect(x: 0, y: 0, width: target.frame.width, height: target.frame.height), styleMask: .fullSizeContentView, backing: .buffered, defer: true, screen: target)
        self.isOpaque = false
        let contentView = NSVisualEffectView()
        contentView.material = .fullScreenUI
        contentView.blendingMode = .behindWindow
        contentView.state = customWindowStyle == .opaque ? .inactive : .active
        self.contentView = contentView
        self.isMovable = false
        self.canBecomeVisibleWithoutLogin = true
        self.collectionBehavior = [.stationary, .canJoinAllSpaces]
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(spaceChange), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    @objc
    private func spaceChange() {
        DispatchQueue.main.async {
            (self.contentView as? NSVisualEffectView)?.state = .inactive
            (self.contentView as? NSVisualEffectView)?.state = .active
        }
    }
}
