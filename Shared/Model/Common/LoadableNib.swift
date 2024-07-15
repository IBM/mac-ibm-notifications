//
//  LoadableNib.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 3/5/20.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

protocol LoadableNib {
    var contentView: NSView! { get }
}

extension LoadableNib where Self: NSView {
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: .init(String(describing: type(of: self))), bundle: bundle)!
        _ = nib.instantiate(withOwner: self, topLevelObjects: nil)

        let contentConstraints = contentView.constraints
        contentView.subviews.forEach({ addSubview($0) })

        for constraint in contentConstraints {
            let firstItem = (constraint.firstItem as? NSView == contentView) ? self : constraint.firstItem
            let secondItem = (constraint.secondItem as? NSView == contentView) ? self : constraint.secondItem
            addConstraint(NSLayoutConstraint(item: firstItem as Any,
                                             attribute: constraint.firstAttribute,
                                             relatedBy: constraint.relation,
                                             toItem: secondItem,
                                             attribute: constraint.secondAttribute,
                                             multiplier: constraint.multiplier,
                                             constant: constraint.constant))
        }
    }
}
