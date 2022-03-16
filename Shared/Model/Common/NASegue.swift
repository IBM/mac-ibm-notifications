//
//  NASegue.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 01/02/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// Override for StoryBoardSegue to control the animation of transitioning between views.
final class NASegue: NSStoryboardSegue {
    override func perform() {
        guard let sourceViewController = self.sourceController as? NSViewController,
              let destinationViewController = self.destinationController as? NSViewController else { return }
        let destinationID = self.identifier
        let containerViewController = sourceViewController.parent

        containerViewController?.insertChild(destinationViewController, at: 1)

        let targetSize = destinationViewController.view.frame.size
        _ = destinationViewController.view.frame.size.width
        _ = destinationViewController.view.frame.size.height

        sourceViewController.view.wantsLayer = true
        destinationViewController.view.wantsLayer = true

        var transitionOption = NSViewController.TransitionOptions.slideForward

        switch destinationID {
        case "goToNextPage", "backToPreviousPage" :
            transitionOption = []
        default :
            transitionOption = NSViewController.TransitionOptions.slideForward
        }

        containerViewController?.transition(from: sourceViewController, to: destinationViewController,
                                            options: transitionOption, completionHandler: nil)

        sourceViewController.view.animator().setFrameSize(targetSize)
        destinationViewController.view.animator().setFrameSize(targetSize)

        _ = containerViewController?.view.window?.frame

        containerViewController?.removeChild(at: 0)
    }
}
