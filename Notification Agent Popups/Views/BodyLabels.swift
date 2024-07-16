//
//  BodyLabels.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/11/22.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import SwiftyMarkdown

/// BodyLabels is a struct that defines a view with the title and the subtitle for the PupUpView.
struct BodyLabels: View {
    
    // MARK: - Environment Variables
    
    @EnvironmentObject var viewSpec: ViewSpec
    
    // MARK: - Variables
    
    var title: String?
    var titleFont: Font?
    var subtitle: String?
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title, !title.isEmpty {
                Text(title)
                    .font(titleFont)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("popup_title")
             }
            if let subtitle = subtitle {
                MarkdownView(text: subtitle.localized, maxViewHeight: 450, containerWidth: viewSpec.accessoryViewWidth)
                    .accessibilityElement()
                    .accessibilityValue(SwiftyMarkdown(string: subtitle).attributedString().string)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityIdentifier("popup_subtitle")
            }
        }
    }
}

struct BodyLabels_Previews: PreviewProvider {
    static var previews: some View {
        BodyLabels(title: "Some Title", subtitle: "Some Subtitle")
    }
}
