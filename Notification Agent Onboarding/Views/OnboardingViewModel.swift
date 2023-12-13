//
//  OnboardingViewModel.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 03/04/2023.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable function_body_length

import Foundation
import Combine
import Cocoa
import SwiftUI

/// OnboardingViewModel define a view model for the OnboardingView struct.
class OnboardingViewModel: NSObject, ObservableObject {

    // MARK: - Variables
    
    var onboardingData: OnboardingData
    var window: NSWindow
    var position: NSWindow.WindowPosition
    var progressBarViewModel: ProgressBarViewModel?
    
    // MARK: - Private Variables
    
    private var outputsStore: [[[String]]]
    private var inputsStore: [[[String]]]
    private var interactiveUpdatesObserver: OnboardingInteractiveEFCLController?
    private var automaticProgressBar: Bool = false
    private var timeoutTimer: Timer?

    // MARK: - Private Variables
    
    private(set) var currentIndex: Int = 0 {
        willSet {
            guard currentIndex < inputsStore.count else { return }
            if inputsStore[currentIndex] != self.pageInputs {
                inputsStore[currentIndex] = self.pageInputs
            }
            guard currentIndex < outputsStore.count else { return }
            if outputsStore[currentIndex] != self.pageOutputs {
                outputsStore[currentIndex] = self.pageOutputs
            }
        }
        didSet {
            isLastPage = currentIndex == (onboardingData.pages.count - 1)
            hideBackButton = currentIndex == 0 || (onboardingData.pages[safe: currentIndex-1]?.singleChange ?? false)
            guard currentIndex < onboardingData.pages.count else { return }
            if let page = onboardingData.pages[safe: currentIndex] {
                primaryButtonState = .enabled
                secondaryButtonState = .enabled
                primaryButtonLabel = page.primaryButtonLabel ?? (isLastPage ? "onboarding_page_close_button".localized : "onboarding_page_continue_button".localized)
                secondaryButtonLabel = page.secondaryButtonLabel ?? "onboarding_page_back_button".localized
                currentPage = page
                guard currentIndex < outputsStore.count && currentIndex < inputsStore.count else { return }
                pageInputs = inputsStore[currentIndex]
                pageOutputs = outputsStore[currentIndex]
            }
        }
    }
    
    // MARK: - Published Variables
    
    @Published var pageInputs: [[String]]
    @Published var pageOutputs: [[String]]
    @Published var helpButtonState: SwiftUIButtonState = .enabled
    @Published var closeButtonState: SwiftUIButtonState = .enabled
    @Published var primaryButtonState: SwiftUIButtonState = .enabled
    @Published var secondaryButtonState: SwiftUIButtonState = .enabled
    @Published var tertiaryButtonState: SwiftUIButtonState = .enabled
    @Published var currentPage: InteractiveOnboardingPage
    @Published var isLastPage: Bool
    @Published var hideBackButton: Bool
    @Published var primaryButtonLabel: String
    @Published var secondaryButtonLabel: String
    
    // MARK: - Initializers
    
    init?(_ onboardingData: OnboardingData, window: NSWindow, position: NSWindow.WindowPosition? = .center, timeout: String? = nil) {
        self.onboardingData = onboardingData
        self.window = window
        self.position = position ?? .center
        guard let firstPage = onboardingData.pages[safe: currentIndex] else { return nil }
        self.currentPage = firstPage
        self.isLastPage = onboardingData.pages.count == 1
        self.hideBackButton = true
        self.primaryButtonLabel = firstPage.primaryButtonLabel ?? (onboardingData.pages.count == 1 ? "onboarding_page_close_button".localized : "onboarding_page_continue_button".localized)
        self.secondaryButtonLabel = firstPage.secondaryButtonLabel ?? "onboarding_page_back_button".localized
        let tempMatrixArray: [[[String]]] = onboardingData.pages.map { page in
            guard page.isValidPage() else {
                NALogger.shared.log("One or more of the provided onboarding pages doesnt provide any information.")
                Utils.applicationExit(withReason: .internalError)
                return []
            }
            return page.accessoryViews.map { matrix in
                return matrix.map { row in
                    return row.map { _ in
                        return ""
                    }
                }
            } ?? []
        }
        self.pageInputs = tempMatrixArray.first ?? []
        self.pageOutputs = tempMatrixArray.first ?? []
        self.outputsStore = tempMatrixArray
        self.inputsStore = tempMatrixArray
        super.init()
        if let timeout = timeout {
            self.setTimeout(timeout)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(repositionWindow), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        if let progressBarPayload = onboardingData.progressBarPayload, onboardingData.pages.count > 1 {
            var payload: String = "/percent 0 /user_interaction_enabled true"
            if progressBarPayload.lowercased() == "automatic" {
                automaticProgressBar = true
            } else {
                payload = progressBarPayload
                interactiveUpdatesObserver = OnboardingInteractiveEFCLController()
                interactiveUpdatesObserver?.startObservingStandardInput()
            }
            self.progressBarViewModel = ProgressBarViewModel(progressState: ProgressState(payload),
                                                             mainButtonState: Binding(get: {
                return self.closeButtonState
            }, set: { newValue, _ in
                guard newValue != self.closeButtonState else { return }
                // Map .hidden state to .disabled
                self.closeButtonState = (newValue == .hidden || newValue == .cancel) ? .disabled : newValue
            }), secondaryButtonState: Binding(get: {
                return .enabled
            }, set: { _, _ in }))
        }
    }
    
    // MARK: - Public Methods
    
    /// React to the user action on the dialog's buttons.
    /// - Parameter type: the user action.
    func didClickButton(of type: UserReplyType) {
        resetTimers()
        switch type {
        case .main:
            if currentIndex >= (onboardingData.pages.count - 1) {
                outputsStore[currentIndex] = self.pageOutputs
                writeStoreOnDevice()
                Utils.applicationExit(withReason: .userFinishedOnboarding)
            } else {
                currentIndex += 1
            }
            writeStoreOnDevice()
            updateProgressBarIfNeeded()
        case .secondary:
            guard currentIndex > 0 else { return }
            currentIndex -= 1
            updateProgressBarIfNeeded()
        case .tertiary:
            if let tertiaryButton = currentPage.tertiaryButton {
                switch tertiaryButton.callToActionType {
                case .link:
                    open(tertiaryButton.callToActionPayload)
                case .exitlink:
                    open(tertiaryButton.callToActionPayload)
                    Utils.applicationExit(withReason: .tertiaryButtonClicked)
                default:
                    break
                }
            }
        case .timeout:
            break
        default:
            break
        }
    }
    
    func open(_ link: String) {
        guard let url = URL(string: link) else {
            NALogger.shared.log("Failed to create a valid URL or App path from payload: %{public}@", [link])
            return
        }
        if ProcessInfo.processInfo.environment["--isRunningTest"] == nil {
            NSWorkspace.shared.open(url)
        }
    }
    
    // MARK: - Private Methods
    
    /// Write the saved store on a file on the user device.
    private func writeStoreOnDevice() {
        guard !outputsStore.isEmpty else { return }
        var plistDictionary: [String : [String: Any]] = [:]
        for (index, page) in outputsStore.enumerated() where page != [] {
            var pageDictionary: [String : Any] = [:]
            page.enumerated().forEach({ element in
                pageDictionary[element.offset.description] = element.element
            })
            plistDictionary[index.description] = pageDictionary
        }
        let dictionaryResult = NSDictionary(dictionary: plistDictionary)
        Utils.write(dictionaryResult, to: Constants.storeFileName)
    }
    
    /// Update the state of the progress bar if it's set to automatic.
    private func updateProgressBarIfNeeded() {
        guard automaticProgressBar else { return }
        let newPercent = ceil(100 / Double(onboardingData.pages.count-1) * Double(currentIndex))
        progressBarViewModel?.progressState = ProgressState("/percent \(min(newPercent, 100))")
    }
    
    /// If needed to set a timeout for the popup this method set the related actions and fire a timer.
    private func setTimeout(_ timeoutString: String) {
        if let timeout = Int(timeoutString) {
            timeoutTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeout),
                                                repeats: false, block: { _ in
                Utils.applicationExit(withReason: .timeout)
            })
        }
    }
    
    private func resetTimers() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
    @objc
    private func repositionWindow() {
        self.window.setWindowPosition(position)
    }
}

//  swiftlint:enable function_body_length

// MARK: - NSWindowDelegate implementation

extension OnboardingViewModel: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        Utils.applicationExit(withReason: .userDismissedOnboarding)
    }
}
