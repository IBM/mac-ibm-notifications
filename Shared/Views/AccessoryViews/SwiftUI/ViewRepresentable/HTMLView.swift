//
//  HTMLView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 24/11/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// HTMLView is a struct that defines a SwiftUI view to display the AppKit HTMLAccessoryView view.
struct HTMLView: NSViewRepresentable {

    // MARK: - Variables
    
    /// The raw text to be displayed in the HTMLAccessoryView.
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
    
    func makeNSView(context: NSViewRepresentableContext<HTMLView>) -> HTMLAccessoryView {
        let markdownTextView = HTMLAccessoryView(withText: text,
                                                 drawsBackground: drawsBackground ?? false,
                                                 maxViewHeight: maxViewHeight ?? 300,
                                                 containerWidth: containerWidth ?? 400)
        return markdownTextView
    }
    
    func updateNSView(_ nsView: HTMLAccessoryView, context: NSViewRepresentableContext<HTMLView>) {}
}

struct HTMLView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLView(text: "**This is a subtitle** [A Link](https://www.google.com) \n Something")
    }
}
