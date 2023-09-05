//
//  OnboardingView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 03/04/2023.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// OnboardingView struct define the main view for the Onboarding UI
struct OnboardingView: View {
    
    // MARK: - State Variables
    
    @State var helpButtonPopoverVisible: Bool = false
    
    // MARK: - Observed Variables
    
    @ObservedObject var viewModel: OnboardingViewModel
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            currentPage
                .accessibilityElement(children: .contain)
            Spacer()
            Divider()
            HStack {
                HStack {
                    if let infoSection = viewModel.currentPage.infoSection {
                        CircleButton(action: {
                            helpButtonPopoverVisible = true
                            viewModel.didClickButton(of: .help)
                        }, infoSection: infoSection, type: .help, buttonState: $viewModel.helpButtonState, showPopover: $helpButtonPopoverVisible)
                        .accessibilityLabel("help_button_label".localized)
                        .accessibilityHint("button_hint_text".localized)
                        .accessibilityIdentifier("help_button")
                    }
                    if let tertiaryButton = viewModel.currentPage.tertiaryButton {
                        StandardButton(action: {
                            viewModel.didClickButton(of: .tertiary)
                        }, label: tertiaryButton.label, buttonState: $viewModel.tertiaryButtonState)
                        .fixedSize()
                        .accessibilityIdentifier("tertiary_button")
                        .accessibilityHint(viewModel.currentPage.tertiaryButton?.callToActionType.accessibilityHint ?? "")
                    }
                    Spacer()
                }
                try? ProgressBarView(viewModel: viewModel.progressBarViewModel)
                    .frame(height: 20)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    .frame(alignment: .center)
                HStack {
                    Spacer()
                    if !viewModel.hideBackButton {
                        StandardButton(action: {
                            viewModel.didClickButton(of: .secondary)
                        }, label: viewModel.secondaryButtonLabel,
                                       buttonState: $viewModel.secondaryButtonState)
                        .fixedSize()
                        .accessibilityIdentifier("secondary_button")
                        .accessibilityHint("onboarding_button_secondary_hint".localized)
                    }
                    if viewModel.isLastPage {
                        StandardButton(action: {
                            viewModel.didClickButton(of: .main)
                        }, label: viewModel.primaryButtonLabel,
                                       buttonState: $viewModel.closeButtonState)
                        .fixedSize()
                        .accessibilityIdentifier("main_button")
                        .accessibilityHint("button_hint_destructive".localized)
                    } else {
                        StandardButton(action: {
                            viewModel.didClickButton(of: .main)
                        }, label: viewModel.primaryButtonLabel,
                                       buttonState: $viewModel.primaryButtonState)
                        .fixedSize()
                        .accessibilityIdentifier("main_button")
                        .accessibilityHint("onboarding_button_primary_hint".localized)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: 832, maxHeight: 600)
    }
    
    var currentPage: some View {
        PageView(viewModel: PageViewModel(page: viewModel.currentPage,
                                          inp: $viewModel.pageInputs,
                                          outp: $viewModel.pageOutputs,
                                          primaryButtonState: $viewModel.primaryButtonState,
                                          secondaryButtonState: $viewModel.secondaryButtonState))
        .padding([.trailing, .leading, .top], 8)
    }
}

// swiftlint:disable force_try

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel(try! OnboardingData(from: testJson), window: NSWindow())!)
            .previewLayout(PreviewLayout.fixed(width: 812, height: 600))
    }
}

// swiftlint:enable force_try

private let testJson: String = "{\"progressBarPayload\":\"/percent 0 /top_message Top Message /bottom_message Bottom Message\",\"pages\":[{\"title\":\"First page's title First page's title First page's title First page's title First page's title First page's title First page's title\",\"subtitle\":\"First page's subtitle\",\"body\":\"First page's body\", \"accessoryViews\":[[{\"type\":\"input\",\"payload\":\"/placeholder Something /title First\"},{\"type\":\"input\",\"payload\":\"/placeholder Something /title Second\"}]]}]}"
