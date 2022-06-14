//
//  TimerAccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 8/10/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol TimerAccessoryViewDelegate: AnyObject {
    func timerDidFinished(_ sender: TimerAccessoryView)
}

/// This view present a label with a built in timer.
final class TimerAccessoryView: AccessoryView {

    // MARK: - Variables
    weak var timerDelegate: TimerAccessoryViewDelegate?
    var timerLabel: NSTextField!
    var timer: Timer?
    var label: String
    var countDown: Int {
        didSet {
            DispatchQueue.main.async {
                self.timerLabel.stringValue = String(format: self.label,
                                                     self.countDown.timeFormattedString)
            }
        }
    }

    // MARK: - Initializers

    init(withTimeInSeconds time: Int, label: String) {
        self.timerLabel = NSTextField(labelWithString: String(format: label,
                                                              time.timeFormattedString))
        self.countDown = time
        self.label = label
        super.init(frame: .zero)
        self.startTimer()
        self.buildView()
        self.identifier = NSUserInterfaceItemIdentifier("timer_accessoryview")
    }

    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Instance methods
    
    override func configureAccessibilityElements() {
        timerLabel.setAccessibilityLabel("accessory_view_accessibility_timer_label".localized)
    }

    // MARK: - Private methods

    private func buildView() {
        timerLabel.lineBreakMode = .byWordWrapping
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerLabel)

        timerLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        configureAccessibilityElements()
    }

    /// Create and fire the timer for the countdown.
    private func startTimer() {
        guard timer == nil else { return }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.updateCountdown()
        })
    }

    /// Update the countdown value.
    private func updateCountdown() {
        guard countDown >= 1 else {
            self.timer?.invalidate()
            self.timer = nil
            self.countDown = 0
            self.timerDelegate?.timerDidFinished(self)
            return
        }
        self.countDown -= 1
    }
}
