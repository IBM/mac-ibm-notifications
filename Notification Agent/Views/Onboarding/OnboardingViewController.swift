//
//  OnboardingViewController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 01/02/2021.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol OnboardingNavigationDelegate: AnyObject {
    func didSelectNextButton(_ sender: OnboardingPageViewController)
    func didSelectBackButton(_ sender: OnboardingPageViewController)
}

class OnboardingViewController: NSViewController {

    // MARK: - Variables

    private var pages: [OnboardingPage]
    private var presentedVC: NSViewController?
    private var presentedPageIndex: Int = 0

    // MARK: - Initializers

    init(with pages: [OnboardingPage]) {
        self.pages = pages
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.pages = []
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPagesConsistency()
        setupLayout()
    }

    // MARK: - Private methods

    /// Check if all the provided pages are valid.
    private func checkPagesConsistency() {
        for page in self.pages {
            guard page.isValidPage() else {
                Logger.shared.log(.error, "One or more of the provided onboarding pages doesnt provide any information.")
                EFCLController.shared.applicationExit(withReason: .internalError)
                return
            }
        }
    }

    /// Define and present the target VC.
    private func setupLayout() {
        let sourceViewController = OnboardingPageViewController(with: pages.first!,
                                                                position: pages.count > 1 ? .first : .singlePage)
        sourceViewController.navigationDelegate = self
        self.insertChild(sourceViewController, at: 0)
        self.view.addSubview(sourceViewController.view)
        self.view.frame = sourceViewController.view.frame
    }
}

// MARK: - OnboardingNavigationDelegate implementation
extension OnboardingViewController: OnboardingNavigationDelegate {
    func didSelectNextButton(_ sender: OnboardingPageViewController) {
        guard presentedPageIndex < pages.count-1, let sourceVC = self.children.first else { return }
        presentedPageIndex += 1
        let destinationVC = OnboardingPageViewController(with: pages[presentedPageIndex],
                                                  position: pages.count-1 == presentedPageIndex ? .last : .middle)
        destinationVC.navigationDelegate = self
        let segue = CrossfadeSegue(identifier: "goToNextPage", source: sourceVC, destination: destinationVC)
        segue.perform()
    }

    func didSelectBackButton(_ sender: OnboardingPageViewController) {
        guard presentedPageIndex > 0, let sourceVC = self.children.first else { return }
        presentedPageIndex -= 1
        let destinationVC = OnboardingPageViewController(with: pages[presentedPageIndex],
                                                         position: presentedPageIndex == 0 ? .first : .middle)
        destinationVC.navigationDelegate = self
        let segue = CrossfadeSegue(identifier: "backToPreviousPage", source: sourceVC, destination: destinationVC)
        segue.perform()
    }
}

// MARK: - NSWindowDelegate implementation
extension OnboardingViewController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        EFCLController.shared.applicationExit(withReason: .userDismissedOnboarding)
    }
}
