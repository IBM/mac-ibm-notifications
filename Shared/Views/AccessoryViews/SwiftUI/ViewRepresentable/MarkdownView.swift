//
//  MarkdownView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/11/22.
//  Copyright © 2022 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// MarkdownView is a struct that defines a SwiftUI view to display the AppKit MarkdownTextView view.
struct MarkdownView: NSViewRepresentable {
    
    // MARK: - Variables
    
    /// The raw text to be displayed in the MarkdownTextView.
    var text: String
    /// Define if it's needed to draw a whit background for the view.
    var drawsBackground: Bool?
    /// Maximum height for the view.
    var maxViewHeight: CGFloat?
    /// Allignement for the text in the view.
    var alignment: NSTextAlignment?
    /// The view container width. Used to calculate the size based on the font.
    var containerWidth: CGFloat?
    
    // MARK: - Protocol Methods
    
    func makeNSView(context: NSViewRepresentableContext<MarkdownView>) -> MarkdownTextView {
        let markdownTextView = MarkdownTextView(withText: text,
                                                drawsBackground: drawsBackground ?? false,
                                                maxViewHeight: maxViewHeight ?? 300,
                                                alignment: alignment ?? .left,
                                                containerWidth: containerWidth ?? 420)
        return markdownTextView
    }
    
    func updateNSView(_ nsView: MarkdownTextView, context: NSViewRepresentableContext<MarkdownView>) {
        nsView.textView.alignment = self.alignment ?? .left
        nsView.maxViewHeight = self.maxViewHeight ?? 300
        nsView.containerWidth = self.containerWidth ?? 420
        if self.drawsBackground ?? false {
            nsView.textViewBackgroundColor = .white
            nsView.textColor = .black
        } else {
            nsView.textViewBackgroundColor = nil
            nsView.textColor = .labelColor
        }
        nsView.needsLayout = true
        nsView.scrollView.needsLayout = true
        nsView.setText(self.text)
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(text: "**This is a subtitle** [A Link](https://www.google.com) \n Something")
    }
}
