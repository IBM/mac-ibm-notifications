//
//  TaggedTextView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 9/21/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view show and handle hyperlinks inside the input text.
final class TaggedTextView: NSView {

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

    var maxViewHeight: CGFloat = 300 {
        didSet {
            adjustViewSize()
        }
    }
    var textColor: NSColor {
        didSet {
            let attributedString = NSMutableAttributedString(attributedString: self.textView.attributedString())
            attributedString.addAttribute(.foregroundColor,
                                          value: textColor,
                                          range: NSRange(location: 0, length: attributedString.string.utf16.count))
            self.textView.textStorage?.setAttributedString(attributedString)
        }
    }
    var backgroundColor: NSColor? {
        didSet {
            guard let backgroundColor = backgroundColor else {
                self.textView.drawsBackground = false
                return
            }
            self.textView.drawsBackground = true
            self.textView.backgroundColor = backgroundColor
        }
    }

    // MARK: - Initializers

    init() {
        textColor = Utils.currentInterfaceStyle == .light ? .black : .white
        super.init(frame: .zero)

        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        textContainer.lineBreakMode = .byWordWrapping
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)

        textView = .init(frame: .zero, textContainer: textContainer)
        textView.textContainerInset = .zero
        textView.font = .systemFont(ofSize: 13)
        textView.isEditable = false
        textView.isSelectable = true
        textView.drawsBackground = false
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
        let attributedString = NSMutableAttributedString(string: text)
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            self.textView.textStorage?.setAttributedString(attributedString)
            return
        }
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        guard matches.count > 0 else {
            self.textView.textStorage?.setAttributedString(attributedString)
            return
        }
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let url = text[range]
            attributedString.addAttribute(.link, value: url, range: match.range)
        }
        attributedString.addAttributes([.font: NSFont.systemFont(ofSize: 13),
                                        .foregroundColor: textColor],
                                      range: NSRange(location: 0,
                                                     length: text.utf16.count))

        self.textView.textStorage?.setAttributedString(attributedString)

        adjustViewSize()
    }

    // MARK: - Private methods

    /// Adjust the view size based on the superview width and on the textView height.
    private func adjustViewSize() {
        let textField = NSTextField(wrappingLabelWithString: self.textView.attributedString().string)
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
