//
//  TimerAccessoryView.swift
//  NotificationAgent
//
//  Created by Simone Martorelli on 8/10/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol TimerAccessoryViewDelegate: class {
    func timerDidFinished(_ sender: TimerAccessoryView)
}

/// This view present a label with a built in timer.
public final class TimerAccessoryView: NSView {

    // MARK: - Variables
    weak var delegate: TimerAccessoryViewDelegate?
    var timerLabel: NSTextField!
    var timer: Timer?
    var countDown: Int {
        didSet {
            DispatchQueue.main.async {
                self.timerLabel.stringValue = String(format: "accessory_view_timer_label".localized,
                                                     self.countDown.timeFormattedString)
            }
        }
    }

    // MARK: - Initializers

    init(withTimeInSeconds time: Int) {
        self.timerLabel = NSTextField(labelWithString: String(format: "accessory_view_timer_label".localized,
                                                              time.timeFormattedString))
        self.countDown = time
        super.init(frame: .zero)
        self.startTimer()
        self.buildView()
    }

    required init?(coder: NSCoder) {
        return nil
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
            self.delegate?.timerDidFinished(self)
            return
        }
        self.countDown -= 1
    }
}
