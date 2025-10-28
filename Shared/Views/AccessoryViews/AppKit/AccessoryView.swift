//
//  AccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 03/05/2021.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol AccessoryViewDelegate: AnyObject {
    func accessoryViewStatusDidChange(_ sender: AccessoryView)
}

/// The base accessory view class
class AccessoryView: NSView {
    enum ButtonState {
        case enabled
        case disabled
        case hidden
    }
    var mainButtonState: ButtonState = .enabled
    var secondaryButtonState: ButtonState = .enabled
    weak var delegate: AccessoryViewDelegate?
    
    // MARK: - Instance Methods
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        adjustViewSize()
        configureAccessibilityElements()
    }
    
    // MARK: - Public Methods
    
    /// Adjust the view size based on the superview width and on the video height.
    func adjustViewSize() {}
    
    func configureAccessibilityElements() {}
    
    func displayStoredData(_ data: String) {}
}
