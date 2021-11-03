//
//  ProgressBarAccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/13/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// The delegate that will communicate outside the event of the progress bar if needed.
protocol ProgressBarAccessoryViewDelegate: AnyObject {
    func didChangeEstimation(_ isIndeterminated: Bool)
}

/// This view show a progress bar and handle the interactive UI updates for it.
class ProgressBarAccessoryView: AccessoryView {

    // MARK: - Private variables

    private var containerWidth: CGFloat {
        return self.superview?.bounds.width ?? 0
    }
    private var progressBar: NSProgressIndicator!
    private var topMessageLabel: NSTextField!
    private var bottomMessageLabel: NSTextField!
    private var viewWidthAnchor: NSLayoutConstraint!
    private var viewState: ProgressState!
    private var interactiveEFCLController: PopupInteractiveEFCLController!

    // MARK: - Public viariables

    var isIndeterminate: Bool {
        return viewState.isIndeterminate
    }
    var isUserInteractionEnabled: Bool {
        return viewState.isUserInteractionEnabled
    }
    var isUserInterruptionAllowed: Bool {
        return viewState.isUserInterruptionAllowed
    }
    var progressCompleted: Bool = false
    weak var progressBarDelegate: ProgressBarAccessoryViewDelegate?

    // MARK: - Initializers

    init(_ payload: String? = nil) {
        super.init(frame: .zero)
        viewState = ProgressState(payload)
        interactiveEFCLController = PopupInteractiveEFCLController(viewState)
        interactiveEFCLController.delegate = self
        configureView()
        secondaryButtonState = self.isUserInteractionEnabled ? .enabled : .hidden
        mainButtonState = self.isUserInterruptionAllowed || self.isUserInteractionEnabled ? .enabled : .hidden
        adjustViewSize()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Instance methods

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        adjustViewSize()
        interactiveEFCLController.startObservingStandardInput()
        configureAccessibilityElements()
    }

    // MARK: - Private methods

    private func configureView() {
        topMessageLabel = NSTextField(labelWithString: viewState.topMessage)
        topMessageLabel.lineBreakMode = .byTruncatingTail
        topMessageLabel.maximumNumberOfLines = 1
        topMessageLabel.font = NSFont.systemFont(ofSize: 12)
        topMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomMessageLabel = NSTextField(labelWithString: viewState.bottomMessage)
        bottomMessageLabel.lineBreakMode = .byTruncatingTail
        bottomMessageLabel.maximumNumberOfLines = 1
        bottomMessageLabel.alphaValue = 0.7225
        bottomMessageLabel.font = NSFont.systemFont(ofSize: 10)
        bottomMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar = NSProgressIndicator()
        progressBar.doubleValue = viewState.percent
        progressBar.isIndeterminate = viewState.isIndeterminate
        if viewState.isIndeterminate {
            self.progressBar.startAnimation(nil)
        }
        progressBar.style = .bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topMessageLabel)
        addSubview(progressBar)
        addSubview(bottomMessageLabel)
        topMessageLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1).isActive = true
        topMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topMessageLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        progressBar.topAnchor.constraint(equalTo: topMessageLabel.bottomAnchor, constant: 4).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        bottomMessageLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor).isActive = true
        bottomMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1).isActive = true
        bottomMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomMessageLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    /// Adjust the view size based on the superview width.
    private func adjustViewSize() {
        viewWidthAnchor?.isActive = false
        viewWidthAnchor = progressBar.widthAnchor.constraint(equalToConstant: self.containerWidth)
        viewWidthAnchor.isActive = true
        progressBar.isBezeled = true
    }
    
    private func configureAccessibilityElements() {
        topMessageLabel.setAccessibilityLabel("accessory_view_accessibility_progressbar_toplabel".localized)
        progressBar.setAccessibilityLabel("accessory_view_accessibility_progressbar_bar".localized)
        bottomMessageLabel.setAccessibilityLabel("accessory_view_accessibility_progressbar_bottomlabel".localized)
    }
}

extension ProgressBarAccessoryView: PopupInteractiveEFCLControllerDelegate {
    /// Update the UI for the new state received.
    /// - Parameter newState: the new state to be showed.
    func didReceivedNewStateforProgressBar(_ newState: ProgressState) {
        DispatchQueue.main.async {
            self.viewState = newState
            self.progressBar.isIndeterminate = self.viewState.isIndeterminate
            if self.viewState.isIndeterminate {
                self.progressBar.startAnimation(nil)
            }
            
            self.mainButtonState = newState.isUserInteractionEnabled || newState.isUserInterruptionAllowed ? .enabled : .hidden
            self.secondaryButtonState = newState.isUserInteractionEnabled ? .enabled : .hidden
            
            NSAnimationContext.runAnimationGroup { (context) in
                context.duration = 0.2
                self.topMessageLabel.animator().stringValue = self.viewState.topMessage
                self.bottomMessageLabel.animator().stringValue = self.viewState.bottomMessage

                if self.viewState.percent >= 100 {
                    self.didFinishedInteractiveUpdates()
                } else if !self.viewState.isIndeterminate {
                    self.progressBar.animator().doubleValue = self.viewState.percent
                    self.delegate?.accessoryViewStatusDidChange(self)
                } else {
                    self.delegate?.accessoryViewStatusDidChange(self)
                }
            }
        }
    }

    /// Interactive updates ended.
    func didFinishedInteractiveUpdates() {
        DispatchQueue.main.async {
            self.progressBar.isIndeterminate = false
            self.progressBar.doubleValue = 100
            self.progressBar.stopAnimation(nil)
            self.progressCompleted = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            guard !self.viewState.exitOnCompletion else {
                EFCLController.shared.applicationExit(withReason: .mainButtonClicked)
                return
            }
            self.mainButtonState = .enabled
            self.secondaryButtonState = .enabled
            self.delegate?.accessoryViewStatusDidChange(self)
        }
    }
}
