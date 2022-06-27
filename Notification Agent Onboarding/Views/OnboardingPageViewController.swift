//
//  OnboardingPageViewController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 21/01/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable function_body_length type_body_length file_length

import Cocoa

final class OnboardingPageViewController: NSViewController {
    
    // MARK: - Enums
    
    /// The position of the page in the onboarding process.
    enum PagePosition {
        case first
        case relativeFirst
        case last
        case middle
        case singlePage
        var rightButtonTitle: String {
            switch self {
            case .first, .relativeFirst:
                return "onboarding_page_continue_button".localized
            case .middle:
                return "onboarding_page_continue_button".localized
            case .last, .singlePage:
                return "onboarding_page_close_button".localized
            }
        }
        var leftButtonTitle: String {
            return "onboarding_page_back_button".localized
        }
        var isRightButtonHidden: Bool {
            switch self {
            case .first, .relativeFirst, .middle, .last, .singlePage:
                return false
            }
        }
        var isLeftButtonHidden: Bool {
            switch self {
            case .first, .relativeFirst, .singlePage:
                return true
            case .middle, .last:
                return false
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var topIconImageView: NSImageView!
    @IBOutlet weak var bodyStackView: NSStackView!
    @IBOutlet weak var rightButton: NSButton!
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var helpButton: NSButton!
    
    // MARK: - Variables
    
    weak var navigationDelegate: OnboardingNavigationDelegate?
    var titleLabel: NSTextField!
    var subtitleLabel: NSTextField!
    var bodyTextView: MarkdownTextView!
    var mediaView: NSView!
    var accessoryViews: [AccessoryView] = []
    var store: [String]
    let page: OnboardingPage
    let position: PagePosition
    
    // MARK: - Initializers
    
    init(with page: OnboardingPage, position: PagePosition, store: [String]? = nil) {
        self.page = page
        self.position = position
        self.store = store ?? []
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkButtonVisibility),
                                               name: .onboardingParentStatusDidChange,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setupStackViewLayout()
        self.setupButtonsLayout()
        self.configureAccessibilityElements()
        self.setIconIfNeeded()
        self.displayStoredData()
    }
    
    // MARK: - Private methods
    
    /// Set up the stackview components and layout.
    private func setupStackViewLayout() {
        self.bodyStackView.distribution = .gravityAreas
        self.bodyStackView.alignment = .centerX
        self.bodyStackView.spacing = 12
        
        var remainingSpace = bodyStackView.bounds.height
        var topGravityAreaIndex = 0
        if let title = page.title {
            titleLabel = NSTextField(wrappingLabelWithString: title)
            titleLabel.font = NSFont.boldSystemFont(ofSize: 26)
            titleLabel.alignment = .center
            titleLabel.setAccessibilityIdentifier("onboarding_accessibility_title")
            bodyStackView.insertView(titleLabel, at: topGravityAreaIndex, in: .top)
            topGravityAreaIndex += 1
            remainingSpace -= titleLabel.intrinsicContentSize.height+12
        }
        if let subtitle = page.subtitle {
            subtitleLabel = NSTextField(wrappingLabelWithString: subtitle)
            subtitleLabel.font = NSFont.systemFont(ofSize: 16, weight: .semibold)
            subtitleLabel.alignment = .center
            subtitleLabel.setAccessibilityIdentifier("onboarding_accessibility_subtitle")
            bodyStackView.insertView(subtitleLabel, at: topGravityAreaIndex, in: .top)
            topGravityAreaIndex += 1
            remainingSpace -= subtitleLabel.intrinsicContentSize.height+12
        }
        if let pageMedia = (page as? LegacyOnboardingPage)?.pageMedia {
            if let body = page.body {
                bodyTextView = MarkdownTextView(withText: body, maxViewHeight: remainingSpace, alignment: .center)
                bodyStackView.insertView(bodyTextView, at: 0, in: .center)
                remainingSpace -= bodyTextView.fittingSize.height+12
            }
            switch pageMedia.mediaType {
            case .image:
                guard pageMedia.image  != nil else { return }
                mediaView = ImageAccessoryView(with: pageMedia, preferredSize: CGSize(width: bodyStackView.bounds.width, height: remainingSpace), needsFullWidth: false)
                bodyStackView.insertView(mediaView, at: 0, in: .bottom)
            case .video:
                guard pageMedia.player != nil else { return }
                mediaView = VideoAccessoryView(with: pageMedia, preferredSize: CGSize(width: bodyStackView.bounds.width, height: remainingSpace), needsFullWidth: false)
                bodyStackView.insertView(mediaView, at: 0, in: .bottom)
            }
        } else if let accessoryViews = (page as? InteractiveOnboardingPage)?.accessoryViews {
            if let body = page.body {
                bodyTextView = MarkdownTextView(withText: body, maxViewHeight: remainingSpace, alignment: .center)
                bodyStackView.insertView(bodyTextView, at: topGravityAreaIndex, in: .top)
                remainingSpace -= bodyTextView.fittingSize.height+12
            }
            self.setupAccessoryViews(accessoryViews, in: remainingSpace)
            self.checkButtonVisibility()
        } else {
            if let body = page.body {
                bodyTextView = MarkdownTextView(withText: body, maxViewHeight: remainingSpace, alignment: .center)
                bodyStackView.insertView(bodyTextView, at: topGravityAreaIndex, in: .top)
            }
        }
    }
    
    /// Setup the accessory views on the current page.
    /// - Parameter accessoryViews: the accessory views related to this page.
    private func setupAccessoryViews(_ accessoryViewsMatrix: [[NotificationAccessoryElement]], in remainingSpace: CGFloat) {
        var avSpaceLeft = remainingSpace
        for row in accessoryViewsMatrix {
            if row.count > 1 {
                let rowBodyStackView = NSStackView()
                rowBodyStackView.alignment = .centerY
                rowBodyStackView.orientation = .horizontal
                rowBodyStackView.spacing = 12
                rowBodyStackView.distribution = .fillEqually
                bodyStackView.addArrangedSubview(rowBodyStackView)
                rowBodyStackView.translatesAutoresizingMaskIntoConstraints = false
                rowBodyStackView.widthAnchor.constraint(equalTo: bodyStackView.widthAnchor, multiplier: 1).isActive = true
                rowBodyStackView.setClippingResistancePriority(.defaultHigh, for: .horizontal)
                let originalSpaceLeft = avSpaceLeft
                for accessoryView in row {
                    var currentSpaceLeft = originalSpaceLeft-6
                    self.addAccessoryView(accessoryView,
                                          in: rowBodyStackView,
                                          dedicatedHeight: &currentSpaceLeft,
                                          dedicatedWidth: bodyStackView.bounds.width/CGFloat(row.count)-6)
                    avSpaceLeft = min(avSpaceLeft, currentSpaceLeft)
                }
                rowBodyStackView.layout()
            } else {
                if let accessoryView = row.first {
                    self.addAccessoryView(accessoryView, in: self.bodyStackView,
                                          at: .center,
                                          withIndex: 0,
                                          dedicatedHeight: &avSpaceLeft,
                                          dedicatedWidth: bodyStackView.bounds.width)
                }
            }
        }
    }
    
    /// Configure and insert the related accessory view.
    /// - Parameter accessoryView: the defined accessory view.
    private func addAccessoryView(_ accessoryView: NotificationAccessoryElement,
                                  in stackView: NSStackView,
                                  at gravity: NSStackView.Gravity? = nil,
                                  withIndex index: Int = 0,
                                  dedicatedHeight: inout CGFloat,
                                  dedicatedWidth: CGFloat) {
        func add(_ view: NSView) {
            if let gravity = gravity {
                stackView.insertView(view, at: index, in: gravity)
            } else {
                stackView.addArrangedSubview(view)
            }
        }
        switch accessoryView.type {
        case .whitebox:
            let markdownTextView = MarkdownTextView(withText: accessoryView.payload ?? "", drawsBackground: true, containerWidth: dedicatedWidth)
            add(markdownTextView)
        case .image:
            guard let media = accessoryView.media, media.image != nil else { return }
            let imageAccessoryView = ImageAccessoryView(with: media, preferredSize: CGSize(width: dedicatedWidth, height: dedicatedHeight), needsFullWidth: false, containerWidth: dedicatedWidth)
            add(imageAccessoryView)
        case .video:
            guard let media = accessoryView.media, media.player != nil else { return }
            let videoAccessoryView = VideoAccessoryView(with: media, preferredSize: CGSize(width: dedicatedWidth, height: dedicatedHeight), needsFullWidth: false, containerWidth: dedicatedWidth)
            videoAccessoryView.delegate = self
            /// Embed the AV inside a container view avoid to expose the black video player background if the video resolution
            /// doesn't match the available space for the video accessory view.
            let containerView = NSView()
            containerView.addSubview(videoAccessoryView)
            videoAccessoryView.translatesAutoresizingMaskIntoConstraints = false
            videoAccessoryView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            videoAccessoryView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            videoAccessoryView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            add(containerView)
        case .input, .securedinput, .secureinput:
            do {
                let inputAccessoryView = try InputAccessoryView(with: accessoryView.payload ?? "",
                                                                isSecure: accessoryView.type == .securedinput || accessoryView.type == .secureinput,
                                                                containerWidth: dedicatedWidth,
                                                                preventResize: true)
                inputAccessoryView.delegate = self
                add(inputAccessoryView)
                self.accessoryViews.append(inputAccessoryView)
                dedicatedHeight -= inputAccessoryView.hasTitle ? 52 : 32
            } catch {
                NALogger.shared.log("Error while creating accessory view: %{public}@", [error.localizedDescription])
            }
        case .dropdown:
            do {
                let dropDownAccessoryView = try DropDownAccessoryView(with: accessoryView.payload ?? "", containerWidth: dedicatedWidth)
                dropDownAccessoryView.delegate = self
                add(dropDownAccessoryView)
                self.accessoryViews.append(dropDownAccessoryView)
                dedicatedHeight -= dropDownAccessoryView.hasTitle ? 52 : 32
            } catch {
                NALogger.shared.log("Error while creating accessory view: %{public}@", [error.localizedDescription])
            }
        case .html:
            let htmlAccessoryView = HTMLAccessoryView(withText: accessoryView.payload ?? "", drawsBackground: false, containerWidth: dedicatedWidth)
            add(htmlAccessoryView)
        case .htmlwhitebox:
            let htmlAccessoryView = HTMLAccessoryView(withText: accessoryView.payload ?? "", drawsBackground: true, containerWidth: dedicatedWidth)
            add(htmlAccessoryView)
        case .checklist:
            do {
                let checklistAccessoryView = try CheckListAccessoryView(with: accessoryView.payload ?? "", containerWidth: dedicatedWidth)
                add(checklistAccessoryView)
                checklistAccessoryView.delegate = self
                self.accessoryViews.append(checklistAccessoryView)
            } catch {
                NALogger.shared.log("Error while creating accessory view: %{public}@", [error.localizedDescription])
            }
        default:
            return
        }
    }
    
    /// Set up buttons appearence.
    private func setupButtonsLayout() {
        rightButton.isHidden = position.isRightButtonHidden
        leftButton.isHidden = position.isLeftButtonHidden
        rightButton.title = position.rightButtonTitle
        leftButton.title = position.leftButtonTitle
        helpButton.isHidden = !(page.infoSection != nil)
    }
    
    /// This method load and set the icon if a custom one was defined.
    private func setIconIfNeeded() {
        if let iconPath = page.topIcon {
            if FileManager.default.fileExists(atPath: iconPath),
               let data = try? Data(contentsOf: URL(fileURLWithPath: iconPath)) {
                let image = NSImage(data: data)
                topIconImageView.image = image
            } else if iconPath.isValidURL,
                      let url = URL(string: iconPath),
                      let data = try? Data(contentsOf: url) {
                let image = NSImage(data: data)
                topIconImageView.image = image
            } else if let imageData = Data(base64Encoded: iconPath, options: .ignoreUnknownCharacters),
                      let image = NSImage(data: imageData) {
                topIconImageView.image = image
            } else {
                NALogger.shared.log("Unable to load image from %{public}@", [iconPath])
            }
        } else {
            topIconImageView.image = NSImage(named: NSImage.Name("default_icon"))
        }
    }
    
    private func goToNextPage() {
        self.navigationDelegate?.didSelectNextButton(self)
    }
    
    private func goToPreviousPage() {
        self.navigationDelegate?.didSelectBackButton(self)
    }
    
    /// Exit the completed onboarding.
    private func closeOnboarding() {
        self.navigationDelegate?.shouldCloseOnboardingWindow(self)
    }
    
    private func configureAccessibilityElements() {
        self.rightButton.setAccessibilityLabel(position == .last ? "onboarding_accessibility_button_right_close".localized : "onboarding_accessibility_button_right_continue".localized)
        self.rightButton.setAccessibilityIdentifier("onboarding_accessibility_button_right")
        self.leftButton.setAccessibilityLabel("onboarding_accessibility_button_left".localized)
        self.leftButton.setAccessibilityIdentifier("onboarding_accessibility_button_left")
        self.helpButton.setAccessibilityLabel("onboarding_accessibility_button_center".localized)
        self.helpButton.setAccessibilityIdentifier("onboarding_accessibility_button_center")
        self.bodyStackView.setAccessibilityLabel("onboarding_accessibility_stackview_body".localized)
        self.bodyStackView.setAccessibilityElement(false)
        self.topIconImageView.setAccessibilityLabel("onboarding_accessibility_image_top".localized)
        self.topIconImageView.setAccessibilityIdentifier("onboarding_accessibility_image_top")
    }
    
    @objc
    private func checkButtonVisibility() {
        var mainButtonState: AccessoryView.ButtonState = .enabled
        var secondaryButtonState: AccessoryView.ButtonState = .enabled
        
        for accessoryView in accessoryViews {
            switch accessoryView.mainButtonState {
            case .disabled, .hidden:
                guard mainButtonState != .hidden else { continue }
                mainButtonState = accessoryView.mainButtonState
            case .enabled:
                continue
            }
        }
        switch mainButtonState {
        case .disabled:
            self.rightButton.isEnabled = false
        case .hidden:
            self.rightButton.isEnabled = false
        case .enabled:
            if let parent = self.parent as? OnboardingViewController, !parent.isClosable && (self.position == .last || self.position == .singlePage) {
                self.rightButton.isEnabled = false
            } else {
                self.rightButton.isEnabled = true
            }
        }
        guard position != .first else { return }
        for accessoryView in accessoryViews {
            switch accessoryView.secondaryButtonState {
            case .disabled, .hidden:
                guard secondaryButtonState != .hidden else { continue }
                secondaryButtonState = accessoryView.secondaryButtonState
            case .enabled:
                break
            }
        }
        switch secondaryButtonState {
        case .disabled:
            self.leftButton.isEnabled = false
        case .hidden:
            self.leftButton.isEnabled = false
        case .enabled:
            self.leftButton.isEnabled = true
        }
    }
    
    /// Display the data previously stored for this page
    private func displayStoredData() {
        guard !store.isEmpty else { return }
        guard store.count == accessoryViews.count else { return }
        for (index, accessoryView) in accessoryViews.enumerated() {
            guard store[index] != "" else { continue }
            accessoryView.displayStoredData(store[index])
        }
    }
    
    // MARK: - Public methods
    
    func collectData() -> [String] {
        var data: [String] = []
        guard !accessoryViews.isEmpty else { return data }
        for accessoryView in accessoryViews {
            switch accessoryView.self {
            case is InputAccessoryView:
                if let value = (accessoryView as? InputAccessoryView)?.inputValue {
                    data.append(value)
                }
            case is DropDownAccessoryView:
                if let value = (accessoryView as? DropDownAccessoryView)?.selectedItem {
                    data.append("\(value.description)")
                }
            case is CheckListAccessoryView:
                if let needsCompletion = (accessoryView as? CheckListAccessoryView)?.needCompletion,
                   !needsCompletion,
                   let values = (accessoryView as? CheckListAccessoryView)?.selectedIndexes {
                    var entry = ""
                    values.forEach({ entry.append("\($0.description) ") })
                    if !entry.isEmpty {
                        entry.removeLast()
                    }
                    data.append(entry)
                }
            default:
                break
            }
        }
        return data
    }
    
    // MARK: - Actions
    
    @IBAction func didPressRightButton(_ sender: NSButton) {
        switch position {
        case .first, .relativeFirst:
            goToNextPage()
        case .middle:
            goToNextPage()
        case .last, .singlePage:
            closeOnboarding()
        }
    }
    
    @IBAction func didPressLeftButton(_ sender: NSButton) {
        switch position {
        case .first, .singlePage, .relativeFirst:
            return
        case .middle:
            goToPreviousPage()
        case .last:
            goToPreviousPage()
        }
    }
    
    @IBAction func didPressHelpButton(_ sender: NSButton) {
        guard let infos = page.infoSection else { return }
        let infoPopupViewController = InfoPopOverViewController(with: infos)
        self.present(infoPopupViewController,
                     asPopoverRelativeTo: sender.convert(sender.bounds, to: self.view),
                     of: self.view,
                     preferredEdge: .maxX,
                     behavior: .semitransient)
    }
}

// MARK: - AccessoryViewDelegate methods implementation.
extension OnboardingPageViewController: AccessoryViewDelegate {
    func accessoryViewStatusDidChange(_ sender: AccessoryView) {
        checkButtonVisibility()
    }
}
