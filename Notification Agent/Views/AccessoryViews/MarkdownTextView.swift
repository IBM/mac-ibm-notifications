//
//  MarkdownTextView.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 9/21/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa
import SwiftyMarkdown

/// This view show and handle hyperlinks inside the input text.
final class MarkdownTextView: NSView {

    // MARK: - Private variables

    private var scrollView: NSScrollView!
    private var textView: NSTextView!
    private var containerWidth: CGFloat {
        return self.superview?.bounds.width ?? 0
    }
    private var scrollViewHeightAnchor: NSLayoutConstraint!
    private var textViewWidthAnchor: NSLayoutConstraint!
    private var textViewHeightAnchor: NSLayoutConstraint!

    // MARK: - Variables

    var maxViewHeight: CGFloat
    private var _textColor: NSColor?
    var textColor: NSColor? {
        get {
            return _textColor
        }
        set {
            guard let textColor = newValue else {
                return
            }
            _textColor = newValue
            let attributedString = NSMutableAttributedString(attributedString: self.textView.attributedString())
            attributedString.addAttribute(.foregroundColor,
                                          value: textColor,
                                          range: NSRange(location: 0, length: attributedString.string.utf16.count))
            self.textView.textStorage?.setAttributedString(attributedString)
        }
    }
    private var _textViewBackgroundColor: NSColor?
    var textViewBackgroundColor: NSColor? {
        get {
            return _textViewBackgroundColor
        }
        set {
            guard let backgroundColor = newValue else {
                self.textView.drawsBackground = false
                self.textView.textContainerInset = CGSize(width: -5, height: 0)
                return
            }
            _textViewBackgroundColor = newValue
            self.textView.drawsBackground = true
            self.textView.backgroundColor = backgroundColor
            self.textView.textContainerInset = CGSize(width: 0, height: 0)
        }
    }

    // MARK: - Initializers

    init(withText text: String, drawsBackground: Bool = false, maxViewHeight: CGFloat = 300) {
        self.maxViewHeight = maxViewHeight
        super.init(frame: .zero)

        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        textContainer.lineBreakMode = .byWordWrapping
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

        textView = .init(frame: .zero, textContainer: textContainer)
        textView.isEditable = false
        textView.isSelectable = true
        textView.translatesAutoresizingMaskIntoConstraints = false

        scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autohidesScrollers = true
        scrollView.verticalScroller = NoBackgroundScroller()
        scrollView.hasVerticalScroller = true
        scrollView.verticalScrollElasticity = .none
        scrollView.documentView = textView
        scrollView.drawsBackground = false

        self.addSubview(scrollView)

        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        if drawsBackground {
            textViewBackgroundColor = .white
            textColor = .black
        } else {
            textViewBackgroundColor = nil
            textColor = .labelColor
        }
        self.setText(text)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Instance methods

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.adjustViewSize()
    }

    // MARK: - Public methods

    /// Set the text and eventually handle hyperlinks.
    /// - Parameter text: the text that needs to be displayed.
    func setText(_ text: String) {
        let markdownText = SwiftyMarkdown(string: text)
        markdownText.setFontColorForAllStyles(with: textView.drawsBackground ? .black : .labelColor)
        markdownText.h1.fontSize = 20
        markdownText.h1.fontStyle = .bold
        markdownText.h2.fontSize = 18
        markdownText.h2.fontStyle = .bold
        markdownText.h3.fontSize = 16
        markdownText.h3.fontStyle = .bold
        
        markdownText.code.color = .gray
        markdownText.code.fontName = "CourierNewPSMT"
        
        let attributedString = markdownText.attributedString()
        self.textView.textStorage?.setAttributedString(attributedString)
    }

    // MARK: - Private methods

    /// Adjust the view size based on the superview width and on the textView height.
    private func adjustViewSize() {
        let textField = NSTextField(labelWithAttributedString: self.textView.attributedString())
        textField.lineBreakMode = .byWordWrapping
        textField.sizeToFit()
        let textViewHeight = textField.sizeThatFits(.init(width: max(containerWidth-15, 0),
                                                          height: 0)).height
        let textViewSize = CGSize(width: containerWidth, height: textViewHeight)
        let scrollViewHeight = min(textViewSize.height, maxViewHeight)

        scrollViewHeightAnchor?.isActive = false
        scrollViewHeightAnchor = scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight)
        scrollViewHeightAnchor?.isActive = true
        textViewWidthAnchor?.isActive = false
        textViewWidthAnchor = textView.widthAnchor.constraint(equalToConstant: max(containerWidth-12, 0))
        textViewWidthAnchor?.isActive = true
        textViewHeightAnchor?.isActive = false
        textViewHeightAnchor = textView.heightAnchor.constraint(equalToConstant: textViewSize.height)
        textViewHeightAnchor?.isActive = true

        textView.textContainer?.size = CGSize(width: textViewSize.width-12, height: textViewSize.height)
    }
}

class NoBackgroundScroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
        self.drawKnob()
    }

    override func mouseEntered(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.1
            self.animator().alphaValue = 0.85
        }
    }

    override func mouseExited(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.15
            self.animator().alphaValue = 0.35
        }
    }
}
