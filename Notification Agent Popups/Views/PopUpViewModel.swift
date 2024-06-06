//
//  PopUpViewModel.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 04/11/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable type_body_length

import SwiftUI
import Combine
import SwiftyMarkdown

/// The PopUpViewModel class define a view model for the popup UI view.
/// It include all the methods and the logics to handle the popup UI workflows.
class PopUpViewModel: ObservableObject {
    
    // MARK: - Constants
    
    let notificationObject: NotificationObject
    let window: NSWindow
    
    // MARK: - Computed properties

    var bodyLabelsAccessibilityValue: String {
        var value = ""
        if let title = notificationObject.title {
            value.append("Title of the window: \(title)\n")
        }
        if let subtitle = notificationObject.subtitle {
            value.append("Subtitle of the window: \(SwiftyMarkdown(string: subtitle).attributedString().string)")
        }
        return value
    }
    var titleFont: Font {
        if let fontSizeString = notificationObject.titleFontSize,
           let fontSize = NumberFormatter().number(from: fontSizeString) {
            return .system(size: CGFloat(truncating: fontSize), weight: .bold)
        }
        return .system(size: NSFont.systemFontSize, weight: .bold)
    }
    var customPopupIcon: NSImage? {
        if let iconPath = notificationObject.iconPath {
            if FileManager.default.fileExists(atPath: iconPath),
               let data = try? Data(contentsOf: URL(fileURLWithPath: iconPath)) {
                let image = NSImage(data: data)
                return image
            } else if iconPath.isValidURL,
                      let url = URL(string: iconPath),
                      let data = try? Data(contentsOf: url) {
                let image = NSImage(data: data)
                return image
            } else if let imageData = Data(base64Encoded: iconPath, options: .ignoreUnknownCharacters),
                      let image = NSImage(data: imageData) {
                return image
            } else if let image = NSImage(systemSymbolName: iconPath, accessibilityDescription: iconPath) {
                return image
            } else {
                NALogger.shared.log("Unable to load image from %{public}@", [iconPath])
            }
        }
        return nil
    }
    
    // MARK: - Variables
    
    var warningButton: DynamicNotificationButton?
    var replyHandler = ReplyHandler.shared
    var helpButtonState: SwiftUIButtonState
    var tertiaryButtonState: SwiftUIButtonState
    var interactiveUpdatesObserver: PopupInteractiveEFCLController?
    var mainButtonStatuses: [Binding<SwiftUIButtonState>] = []
    var secondaryButtonStatuses: [Binding<SwiftUIButtonState>] = []
    var reminderTimer: Timer?
    var timeoutTimer: Timer?
    var countDown: Int = 0
    var viewSpec: ViewSpec
    var primaryButtonStates: [SwiftUIButtonState] = []
    var secondaryButtonStates: [SwiftUIButtonState] = []
    var accessoryViews: [AccessoryViewWrapper] = []
    var outputs: [String] = []

    // MARK: - Published Variables
    
    @Published var primaryButtonState: SwiftUIButtonState
    @Published var secondaryButtonState: SwiftUIButtonState
    @Published var warningButtonState: SwiftUIButtonState
    @Published var timerAVInput: String = ""
    @Published var primaryAVMainButtonState: SwiftUIButtonState = .enabled
    @Published var primaryAVSecButtonState: SwiftUIButtonState = .enabled
    @Published var secondaryAVMainButtonState: SwiftUIButtonState = .enabled
    @Published var secondaryAVSecButtonState: SwiftUIButtonState = .enabled
    @Published var showHelpButtonPopover: Bool = false
    @Published var showWarningButtonPopover: Bool = false
    @Published var mainButton: NotificationButton
            
    // MARK: - Initializers
    
    init(_ notificationObject: NotificationObject, window: NSWindow) {
        self.notificationObject = notificationObject
        self.window = window
        mainButton = notificationObject.mainButton
        primaryButtonState = notificationObject.buttonless ? .hidden : .enabled
        secondaryButtonState = notificationObject.secondaryButton != nil ? (notificationObject.buttonless ? .hidden : .enabled) : .hidden
        tertiaryButtonState = notificationObject.tertiaryButton != nil ? .enabled : .hidden
        helpButtonState = notificationObject.helpButton != nil ? .enabled : .hidden
        warningButtonState = notificationObject.warningButton?.isVisible ?? false ? .enabled : .hidden
        let viewWidth = CGFloat(truncating: NumberFormatter().number(from: notificationObject.customWidth ?? "520") ?? .init(integerLiteral: 520))
        var iconSize: CGSize = .zero
        if let widthString = notificationObject.iconWidth,
           let width = NumberFormatter().number(from: widthString),
           let heightString = notificationObject.iconHeight,
           let height = NumberFormatter().number(from: heightString) {
            iconSize = CGSize(width: CGFloat(truncating: width), height: CGFloat(truncating: height))
        } else {
            iconSize = CGSize(width: 60, height: 60)
        }
        viewSpec = ViewSpec(mainViewWidth: viewWidth, iconSize: iconSize)

        NotificationCenter.default.addObserver(self, selector: #selector(repositionWindow), name: NSApplication.didChangeScreenParametersNotification, object: nil)

        if let warningButton = notificationObject.warningButton {
            warningButton.delegate = self
            warningButton.startObservingForUpdates()
            self.warningButton = warningButton
        }
        setupAccessoryViews()
        setRemindTimerIfNeeded()
        setInteractiveUpdatesIfNeeded()
    }
    
    // MARK: - Public Methods
    
    /// React to the user action on the dialog's buttons.
    /// - Parameter type: the user action.
    @MainActor
    func didClickButton(of type: UserReplyType) {
        switch type {
        case .main:
            printOutputIfAvailable()
            triggerAction(ofType: primaryButtonState == .cancel ? .cancel : .main)
        case .secondary:
            if let retainValues = notificationObject.retainValues, retainValues {
                printOutputIfAvailable()
            }
            triggerAction(ofType: .secondary)
        case .tertiary:
            triggerAction(ofType: .tertiary)
        case .help:
            switch notificationObject.helpButton?.callToActionType ?? .infopopup {
            case .infopopup:
                showHelpButtonPopover.toggle()
            case .link:
                triggerAction(ofType: .help)
            default:
                break
            }
        case .warning:
            switch notificationObject.warningButton?.callToActionType ?? .infopopup {
            case .infopopup:
                showWarningButtonPopover.toggle()
            case .link:
                triggerAction(ofType: .warning)
            default:
                break
            }
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    
    /// This method wrap and bind the accessory views - if present - with the view model
    /// in order to be able to react to changes occurred in those accessory views.
    private func setupAccessoryViews() {
        for (item, accessoryView) in (notificationObject.accessoryViews ?? []).enumerated() {
            var primaryButtonState: SwiftUIButtonState = .enabled
            primaryButtonStates.append(primaryButtonState)
            var secondaryButtonState: SwiftUIButtonState = .enabled
            secondaryButtonStates.append(secondaryButtonState)
            self.outputs.append(accessoryView.type == .dropdown ? "-1" : "")
            
            accessoryViews.append(AccessoryViewWrapper(source: AccessoryViewSource(output: Binding(get: {
                return self.outputs[item]
            }, set: { newValue, _ in
                guard newValue != self.outputs[item] else { return }
                self.outputs[item] = newValue
                self.evaluateBindings()
            }), mainButtonState: Binding(get: {
                return primaryButtonState
            }, set: { newValue, _ in
                guard newValue != primaryButtonState else { return }
                primaryButtonState = newValue
                self.evaluateBindings()
            }), secondaryButtonState: Binding(get: {
                return secondaryButtonState
            }, set: { newValue, _ in
                guard newValue != secondaryButtonState else { return }
                secondaryButtonState = newValue
                self.evaluateBindings()
            }), accessoryView: accessoryView)))
            
        }
        setTimeoutIfNeeded()
    }
    
    /// Evaluate the current state of the binded variables.
    private func evaluateBindings() {
        var localPrimaryButtonState: SwiftUIButtonState = .enabled
        var localSecondaryButtonState: SwiftUIButtonState = .enabled
        for acv in accessoryViews {
            switch acv.source.mainButtonState {
            case .enabled:
                break
            case .disabled:
                localPrimaryButtonState = .disabled
            case .hidden:
                localPrimaryButtonState = .hidden
            case .cancel:
                break
            }
            switch acv.source.secondaryButtonState {
            case .enabled:
                break
            case .disabled:
                localSecondaryButtonState = .disabled
            case .hidden:
                localSecondaryButtonState = .hidden
            case .cancel:
                break
            }
        }
        if self.primaryButtonState != localPrimaryButtonState {
            self.primaryButtonState = localPrimaryButtonState
        }
        guard notificationObject.secondaryButton != nil else { return }
        if self.secondaryButtonState != localSecondaryButtonState {
            self.secondaryButtonState = localSecondaryButtonState
        }
    }
    
    /// Send the relative user action to the replyHandler.
    /// - Parameter type: the user action.
    private func triggerAction(ofType type: UserReplyType) {
        self.replyHandler.handleResponse(ofType: type, for: self.notificationObject)
        switch type {
        case .main, .secondary, .timeout:
            DispatchQueue.main.async {
                self.closeWindow()
            }
        default:
            break
        }
    }
    
    /// Close the popup window.
    private func closeWindow() {
        resetTimers()
        window.close()
    }
    
    /// Invalidate and delete the existing timer.
    private func resetTimers() {
        reminderTimer?.invalidate()
        reminderTimer = nil
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
    /// If needed to set a timeout for the popup this method set the related actions and fire a timer.
    private func setTimeoutIfNeeded() {
        if let timeoutString = notificationObject.timeout, let timeout = Int(timeoutString) {
            countDown = timeout
            if let accv = accessoryViews.first(where: { $0.source.accessoryView.type == .timer }), let payload = accv.source.accessoryView.payload {
                timerAVInput = String.init(format: payload, arguments: [timeout.timeFormattedString])
                timeoutTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                    self.updateCountdown()
                    self.timerAVInput = String(format: payload, arguments: [self.countDown.timeFormattedString])
                })
                return
            }
            timeoutTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeout),
                                                repeats: false, block: { [weak self] _ in
                self?.printOutputIfAvailable()
                self?.triggerAction(ofType: .timeout)
            })
        }
    }

    /// Update the countdown value.
    private func updateCountdown() {
        guard countDown >= 2 else {
            timeoutTimer?.invalidate()
            timeoutTimer = nil
            countDown = 0
            printOutputIfAvailable()
            triggerAction(ofType: .timeout)
            return
        }
        countDown -= 1
    }
    
    /// If needed to set a pop-up reminder timeout for the user this method set the related actions and fire a timer.
    private func setRemindTimerIfNeeded(_ repeated: Bool = false) {
        guard let popupReminder = notificationObject.popupReminder,
              notificationObject.alwaysOnTop == false else { return }
        if repeated {
            guard popupReminder.repeatReminder else { return }
        }
        reminderTimer = Timer.scheduledTimer(withTimeInterval: popupReminder.timeInterval,
                                           repeats: false, block: { [weak self] _ in
            self?.window.orderFrontRegardless()
            self?.window.setWindowPosition(self?.notificationObject.position ?? .center)
            if self?.notificationObject.silent == false && !popupReminder.silent {
                NSSound(named: .init("Funk"))?.play()
            }
            self?.setRemindTimerIfNeeded(true)
        })
    }
    
    private func setInteractiveUpdatesIfNeeded() {
        guard notificationObject.accessoryViews?.contains(where: { $0.type == .progressbar }) ?? false || notificationObject.warningButton != nil else { return }
        interactiveUpdatesObserver = PopupInteractiveEFCLController()
        interactiveUpdatesObserver?.startObservingStandardInput()
    }
    
    private func printOutputIfAvailable() {
        for (index, accessoryView) in accessoryViews.enumerated() {
            switch accessoryView.source.accessoryView.type {
            case .checklist:
                if let payload = accessoryView.source.accessoryView.payload,
                   !payload.localizedStandardContains("/complete") && !outputs[index].isEmpty && !(outputs[index] == "-1") {
                    print(outputs[index])
                }
            case .input, .secureinput, .securedinput, .dropdown, .datepicker :
                if !outputs[index].isEmpty {
                    print(outputs[index])
                }
            default:
                break
            }
        }
    }
    
    @objc
    private func repositionWindow() {
        self.window.setWindowPosition(notificationObject.position ?? .center)
    }
}

// MARK: - DynamicNotificationButtonDelegate methods implementation.
extension PopUpViewModel: DynamicNotificationButtonDelegate {
    @MainActor
    func didReceivedNewStateForWarningButton(_ isVisible: Bool, isExpanded: Bool) {
        if self.warningButtonState != (isVisible ? .enabled : .hidden) {
            self.warningButtonState = isVisible ? .enabled : .hidden
        }
        if self.showWarningButtonPopover != isExpanded {
            self.showWarningButtonPopover = isExpanded
        }
    }
}

//  swiftlint:enable type_body_length
