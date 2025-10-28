//
//  PopUpView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 04/11/22.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// PopUpView struct define the main view for the popup UI.
struct PopUpView: View {
    
    // MARK: - Observed Variables
    
    /// This variable define the observed view model on which is based the PopUpView
    @ObservedObject var viewModel: PopUpViewModel

    // MARK: - Views
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                Icon(icon: viewModel.customPopupIcon, iconSize: viewModel.viewSpec.iconSize)
                    .accessibilityIdentifier("popup_icon")
                Spacer(minLength: 8)
                HStack(spacing: 4) {
                    CircleButton(action: {
                        self.viewModel.didClickButton(of: .help)
                    },
                                 popoverText: self.viewModel.notificationObject.helpButton?.callToActionPayload.localized,
                                 type: .help,
                                 buttonState: $viewModel.helpButtonState,
                                 showPopover: $viewModel.showHelpButtonPopover)
                    .accessibilityLabel("help_button_label".localized)
                    .accessibilityHint(viewModel.notificationObject.helpButton?.callToActionType.accessibilityHint ?? "")
                    .accessibilityIdentifier("help_button")
                    CircleButton(action: {
                        self.viewModel.didClickButton(of: .warning)
                    },
                                 popoverText: self.viewModel.notificationObject.warningButton?.callToActionPayload.localized,
                                 type: .warning,
                                 buttonState: $viewModel.warningButtonState,
                                 showPopover: $viewModel.showWarningButtonPopover)
                    .accessibilityLabel("warning_button_label".localized)
                    .accessibilityHint(viewModel.notificationObject.warningButton?.callToActionType.accessibilityHint ?? "")
                    .accessibilityIdentifier("warning_button")
                }
            }
            VStack(alignment: .leading) {
                BodyLabels(title: viewModel.notificationObject.title,
                           titleFont: viewModel.titleFont,
                           subtitle: viewModel.notificationObject.subtitle)
                .environmentObject(viewModel.viewSpec)
                .padding(.bottom, 8)
                if !viewModel.accessoryViews.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.accessoryViews, id: \.hashValue) { accessoryView in
                            switch accessoryView.source.accessoryView.type {
                            case .timer:
                                Text($viewModel.timerAVInput.wrappedValue.localized)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .accessibilityIdentifier("timer_accessory_view")
                            default:
                                accessoryView
                                    .environmentObject(viewModel.viewSpec)
                            }
                        }
                    }
                }
                Spacer(minLength: 12)
                HStack {
                    StandardButton(action: {
                        self.viewModel.didClickButton(of: .tertiary)
                    }, label: viewModel.notificationObject.tertiaryButton?.label ?? "", buttonState: $viewModel.tertiaryButtonState)
                    .accessibilityHint(viewModel.notificationObject.tertiaryButton?.callToActionType.accessibilityHint ?? "")
                    .accessibilityIdentifier("tertiary_button")
                    Spacer(minLength: 8)
                    StandardButton(action: {
                        self.viewModel.didClickButton(of: .secondary)
                    }, label: viewModel.notificationObject.secondaryButton?.label ?? "", buttonState: $viewModel.secondaryButtonState)
                    .accessibilityHint(viewModel.notificationObject.secondaryButton?.callToActionType.accessibilityHint ?? "")
                    .accessibilityIdentifier("secondary_button")
                    StandardButton(keyboardShortcut: .return, action: {
                        self.viewModel.didClickButton(of: .main)
                    }, label: viewModel.notificationObject.mainButton.label, buttonState: $viewModel.primaryButtonState)
                    .accessibilityHint(viewModel.notificationObject.mainButton.callToActionType.accessibilityHint)
                    .accessibilityIdentifier("main_button")
                }
            }
        }
        .padding(EdgeInsets(top: viewModel.notificationObject.hideTitleBar ? -10 : 16, leading: 16, bottom: 16, trailing: 16))
        .frame(width: viewModel.viewSpec.mainViewWidth)
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(viewModel: PopUpViewModel(notificationObject, window: NSWindow()))
            .previewLayout(.fixed(width: 520, height: 150))
    }
}

//  swiftlint:disable force_try

private let notificationObject = try! NotificationObject(from: ["type":"popup",
                                                                "title":"This is a title",
                                                                "subtitle":"**This is a subtitle** [A Link](https://www.google.com) \n Something",
                                                                "main_button_label":"Main",
                                                                "secondary_button_label":"Secondary",
                                                                "tertiary_button_label":"Tertiary",
                                                                "tertiary_button_cta_type":"link",
                                                                "tertiary_button_cta_payload":"https://www.google.com",
                                                                "help_button_cta_type":"link",
                                                                "help_button_cta_payload":"https://www.ibm.com",
                                                                "accessory_view_type":"image",
                                                                "accessory_view_payload":"/Users/simonemartorelli.max/Desktop/test.png",
                                                                "secondary_accessory_view_type":"input",
                                                                "secondary_accessory_view_payload":"/title title /value some"])

//  swiftlint:enable force_try
