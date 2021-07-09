//
//  OnboardingPageViewController.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 21/01/2021.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

final class OnboardingPageViewController: NSViewController {

    // MARK: - Enums

    /// The position of the page in the onboarding process.
    enum PagePosition {
        case first
        case last
        case middle
        case singlePage
        var rightButtonImage: NSImage {
            switch self {
            case .first:
                return NSImage(named: "arrow.right.circle")!
            case .middle:
                return NSImage(named: "arrow.right.circle")!
            case .last, .singlePage:
                return NSImage(named: "checkmark.circle")!
            }
        }
        var leftButtonImage: NSImage {
            switch self {
            case .first, .singlePage:
                return NSImage()
            case .middle:
                return NSImage(named: "arrow.left.circle")!
            case .last:
                return NSImage(named: "arrow.left.circle")!
            }
        }
        var isRightButtonHidden: Bool {
            switch self {
            case .first, .middle, .last, .singlePage:
                return false
            }
        }
        var isLeftButtonHidden: Bool {
            switch self {
            case .first, .singlePage:
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
    @IBOutlet weak var centerButton: NSButton!

    // MARK: - Variables

    weak var navigationDelegate: OnboardingNavigationDelegate?
    var titleLabel: NSTextField!
    var subtitleLabel: NSTextField!
    var bodyTextView: MarkdownTextView!
    var mediaView: NSView!
    let logger = Logger.shared
    let page: OnboardingPage
    let position: PagePosition

    // MARK: - Initializers

    init(with page: OnboardingPage, position: PagePosition) {
        self.page = page
        self.position = position
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods

    override func viewWillAppear() {
        super.viewWillAppear()
        setupStackViewLayout()
        setupButtonsLayout()
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
            titleLabel.font = NSFont.systemFont(ofSize: 32)
            bodyStackView.insertView(titleLabel, at: topGravityAreaIndex, in: .top)
            topGravityAreaIndex += 1
            remainingSpace -= titleLabel.intrinsicContentSize.height+12
        }
        if let subtitle = page.subtitle {
            subtitleLabel = NSTextField(wrappingLabelWithString: subtitle)
            subtitleLabel.font = NSFont.systemFont(ofSize: 18)
            bodyStackView.insertView(subtitleLabel, at: topGravityAreaIndex, in: .top)
            topGravityAreaIndex += 1
            remainingSpace -= subtitleLabel.intrinsicContentSize.height+12
        }
        if let pageMedia = page.pageMedia {
            if let body = page.body {
                bodyTextView = MarkdownTextView(withText: body, maxViewHeight: remainingSpace)
                bodyStackView.insertView(bodyTextView, at: 0, in: .center)
                remainingSpace -= bodyTextView.fittingSize.height+12
            }
            switch pageMedia.mediaType {
            case .image:
                guard pageMedia.image  != nil else { return }
                mediaView = ImageAccessoryView(with: pageMedia, needsFullWidth: false)
                bodyStackView.insertView(mediaView, at: 0, in: .bottom)
            case .video:
                guard pageMedia.player != nil else { return }
                mediaView = VideoAccessoryView(with: pageMedia, preferredSize: CGSize(width: bodyStackView.bounds.width, height: remainingSpace), needsFullWidth: false)
                bodyStackView.insertView(mediaView, at: 0, in: .bottom)
            }
        } else {
            if let body = page.body {
                bodyTextView = MarkdownTextView(withText: body, maxViewHeight: remainingSpace)
                bodyStackView.insertView(bodyTextView, at: topGravityAreaIndex, in: .top)
            }
        }
    }

    /// Set up buttons appearence.
    private func setupButtonsLayout() {
        rightButton.isHidden = position.isRightButtonHidden
        leftButton.isHidden = position.isLeftButtonHidden
        rightButton.image = position.rightButtonImage
        leftButton.image = position.leftButtonImage
        if page.infoSection != nil {
            centerButton.isHidden = false
            centerButton.image = NSImage(named: "info.circle")
        } else {
            centerButton.isHidden = true
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
        EFCLController.shared.applicationExit(withReason: .userFinishedOnboarding)
    }

    // MARK: - Actions

    @IBAction func didPressRightButton(_ sender: NSButton) {
        switch position {
        case .first:
            goToNextPage()
        case .middle:
            goToNextPage()
        case .last, .singlePage:
            closeOnboarding()
        }
    }

    @IBAction func didPressLeftButton(_ sender: NSButton) {
        switch position {
        case .first, .singlePage:
            return
        case .middle:
            goToPreviousPage()
        case .last:
            goToPreviousPage()
        }
    }

    @IBAction func didPressCenterButton(_ sender: NSButton) {
        guard let infos = page.infoSection else { return }
        let infoPopupViewController = InfoPopOverViewController(with: infos)
        self.present(infoPopupViewController,
                     asPopoverRelativeTo: sender.convert(sender.bounds, to: self.view),
                     of: self.view,
                     preferredEdge: .maxX,
                     behavior: .semitransient)
    }
}
