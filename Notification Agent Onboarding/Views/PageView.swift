//
//  PageView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 05/04/2023.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import SwiftyMarkdown

/// PageView struct define a view for the Page inside an Onboarding UI.
struct PageView: View {
    
    // MARK: - Variables
    
    @ObservedObject var viewModel: PageViewModel
    
    // MARK: - Computed Variables
    
    var customPopupIcon: NSImage? {
        if let iconPath = viewModel.page.topIcon {
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
            } else if let image = NSImage(systemSymbolName: iconPath, accessibilityDescription: nil) {
                return image
            } else {
                NALogger.shared.log("Unable to load image from %{public}@", [iconPath])
            }
        }
        return nil
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Icon(icon: customPopupIcon, iconSize: CGSize(width: 86, height: 86))
                .padding(.top, 16)
                .accessibilityHidden(true)
            if let title = viewModel.page.title {
                Text(title)
                    .font(.bold(.title)())
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("onboarding_title")
            }
            if #available(macOS 12, *) {
                if let subtitle = viewModel.page.subtitle {
                    Text(AttributedString(markdownText(subtitle).attributedString()))
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityIdentifier("onboarding_subtitle")
                }
                if let body = viewModel.page.body {
                    Text(AttributedString(markdownText(body).attributedString()))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 8)
                        .accessibilityIdentifier("onboarding_body")
                }
            } else {
                if let subtitle = viewModel.page.subtitle {
                    Text(subtitle)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityIdentifier("onboarding_subtitle")
                }
                if let body = viewModel.page.body {
                    Text(body)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                        .accessibilityIdentifier("onboarding_body")
                }
            }

            if !viewModel.accessoryViewsMatrix.isEmpty {
                VStack(alignment: .center) {
                    ForEach(viewModel.accessoryViewsMatrix, id: \.hashValue) { row in
                        HStack(alignment: .top) {
                            ForEach(row, id: \.hashValue) { accessoryView in
                                accessoryView
                            }
                        }
                    }
                }
                .padding([.top, .leading, .trailing], 16)
            }
            Spacer()
        }
        .onAppear {
            viewModel.evaluateBindings()
        }
    }
    
    func markdownText(_ string: String) -> SwiftyMarkdown {
        let markdownText = SwiftyMarkdown(string: string)
        markdownText.h1.fontSize = 20
        markdownText.h1.fontStyle = .bold
        markdownText.h2.fontSize = 18
        markdownText.h2.fontStyle = .bold
        markdownText.h3.fontSize = 16
        markdownText.h3.fontStyle = .bold
        markdownText.link.color = .linkColor
        markdownText.code.fontName = "Courier New"
        markdownText.blockquotes.color = .gray
        markdownText.blockquotes.fontStyle = .italic
        markdownText.bullet = "•"
        return markdownText
    }
}
