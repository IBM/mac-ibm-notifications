//
//  OnboardingViewController.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 01/02/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol OnboardingNavigationDelegate: AnyObject {
    func didSelectNextButton(_ sender: OnboardingPageViewController)
    func didSelectBackButton(_ sender: OnboardingPageViewController)
    func shouldCloseOnboardingWindow(_ sender: OnboardingPageViewController)
}

class OnboardingViewController: NSViewController {

    // MARK: - Variables

    private var pages: [OnboardingPage]
    private var store: [[String]]
    private var alwaysOnTop: Bool
    private var presentedVC: NSViewController?
    private var presentedPageIndex: Int = 0
    private var commonProgressBar: ProgressBarAccessoryView!
    private var interactiveUpdatesObserver: OnboardingInteractiveEFCLController?
    let context = Context.main
    let logger = NALogger.shared
    var isClosable: Bool = true

    // MARK: - Initializers

    init(with onboardingData: OnboardingData, alwaysOnTop: Bool = false) {
        self.pages = onboardingData.pages
        if let progressBarPayload = onboardingData.progressBarPayload {
            self.commonProgressBar = ProgressBarAccessoryView(progressBarPayload)
            if !commonProgressBar.progressCompleted {
                self.isClosable = false
            }
        }
        self.alwaysOnTop = alwaysOnTop
        var defaultStore: [[String]] = []
        pages.forEach({ _ in defaultStore.append([]) })
        self.store = defaultStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPagesConsistency()
        setupLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.level = alwaysOnTop ? .floating : .normal
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        NotificationCenter.default.post(name: .onboardingParentStatusDidChange,
                                        object: self,
                                        userInfo: nil)
    }

    // MARK: - Private methods

    /// Check if all the provided pages are valid.
    private func checkPagesConsistency() {
        for page in self.pages {
            guard page.isValidPage() else {
                logger.log("One or more of the provided onboarding pages doesnt provide any information.")
                Utils.applicationExit(withReason: .internalError)
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
        guard commonProgressBar != nil else { return }
        commonProgressBar.frame = NSRect(x: 208, y: 8, width: 400, height: 40)
        commonProgressBar.delegate = self
        isClosable = false
        self.view.addSubview(commonProgressBar)
        interactiveUpdatesObserver = OnboardingInteractiveEFCLController()
        interactiveUpdatesObserver?.startObservingStandardInput()
    }
    
    /// Write the saved store on a file on the user device.
    private func writeStoreOnDevice() {
        guard !store.isEmpty else { return }
        var plistDictionary: [String : [String: Any]] = [:]
        for (index, page) in store.enumerated() {
            if page != [] {
                var pageDictionary: [String : Any] = [:]
                page.enumerated().forEach({ element in
                    pageDictionary[element.offset.description] = element.element
                })
                plistDictionary[index.description] = pageDictionary
            }
        }
        let dictionaryResult = NSDictionary(dictionary: plistDictionary)
        Utils.write(dictionaryResult, to: Constants.storeFileName)
    }
}

// MARK: - OnboardingNavigationDelegate implementation
extension OnboardingViewController: OnboardingNavigationDelegate {
    func didSelectNextButton(_ sender: OnboardingPageViewController) {
        guard presentedPageIndex < pages.count-1, let sourceVC = self.children.first else { return }
        store[presentedPageIndex] = sender.collectData()
        let nextPageRelativePosition: OnboardingPageViewController.PagePosition = (pages[presentedPageIndex] as? InteractiveOnboardingPage)?.singleChange ?? false ? (pages.count-1 == presentedPageIndex+1 ? .singlePage : .relativeFirst) : (pages.count-1 == presentedPageIndex+1 ? .last : .middle)
        presentedPageIndex += 1
        let destinationVC = OnboardingPageViewController(with: pages[presentedPageIndex],
                                                         position: nextPageRelativePosition,
                                                         store: store[presentedPageIndex])
        destinationVC.navigationDelegate = self
        writeStoreOnDevice()
        let segue = NASegue(identifier: "goToNextPage", source: sourceVC, destination: destinationVC)
        segue.perform()
    }

    func didSelectBackButton(_ sender: OnboardingPageViewController) {
        guard presentedPageIndex > 0, let sourceVC = self.children.first else { return }
        store[presentedPageIndex] = sender.collectData()
        presentedPageIndex -= 1
        let nextPageRelativePosition: OnboardingPageViewController.PagePosition = presentedPageIndex == 0 ? .first : (pages[presentedPageIndex-1] as? InteractiveOnboardingPage)?.singleChange ?? false ? .relativeFirst : .middle
        let destinationVC = OnboardingPageViewController(with: pages[presentedPageIndex],
                                                         position: nextPageRelativePosition,
                                                         store: store[presentedPageIndex])
        destinationVC.navigationDelegate = self
        let segue = NASegue(identifier: "backToPreviousPage", source: sourceVC, destination: destinationVC)
        segue.perform()
    }
    
    func shouldCloseOnboardingWindow(_ sender: OnboardingPageViewController) {
        store[presentedPageIndex] = sender.collectData()
        writeStoreOnDevice()
        Utils.applicationExit(withReason: .userFinishedOnboarding)
    }
}

// MARK: - NSWindowDelegate implementation
extension OnboardingViewController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        Utils.applicationExit(withReason: .userDismissedOnboarding)
    }
}

// MARK: - AccessoryViewDelegate implementation
extension OnboardingViewController: AccessoryViewDelegate {
    func accessoryViewStatusDidChange(_ sender: AccessoryView) {
        self.isClosable = commonProgressBar?.progressCompleted ?? true
        NotificationCenter.default.post(name: .onboardingParentStatusDidChange,
                                        object: self,
                                        userInfo: nil)
    }
}
