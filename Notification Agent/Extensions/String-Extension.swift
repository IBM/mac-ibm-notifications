//
//  String-Extension.swift
//  NotificationAgent
//
//  Created by Simone Martorelli on 8/10/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Foundation
import Cocoa

private typealias TerminalStyleFormatCode = (start: String, end: String)

private struct TerminalStyleFormat {
    public static let black: TerminalStyleFormatCode           = ("\u{001B}[30m", "\u{001B}[0m")
    public static let white: TerminalStyleFormatCode           = ("\u{001B}[97m", "\u{001B}[0m")
    public static let red: TerminalStyleFormatCode             = ("\u{001B}[31m", "\u{001B}[0m")
    public static let green: TerminalStyleFormatCode           = ("\u{001B}[32m", "\u{001B}[0m")
    public static let yellow: TerminalStyleFormatCode          = ("\u{001B}[33m", "\u{001B}[0m")
    public static let blue: TerminalStyleFormatCode            = ("\u{001B}[34m", "\u{001B}[0m")
    public static let cyan: TerminalStyleFormatCode            = ("\u{001B}[36m", "\u{001B}[0m")
    public static let lightGray: TerminalStyleFormatCode       = ("\u{001B}[37m", "\u{001B}[0m")
    public static let darkGray: TerminalStyleFormatCode        = ("\u{001B}[90m", "\u{001B}[0m")
    public static let bold: TerminalStyleFormatCode            = ("\u{001B}[1m", "\u{001B}[22m")
    public static let italic: TerminalStyleFormatCode          = ("\u{001B}[3m", "\u{001B}[23m")
    public static let underline: TerminalStyleFormatCode       = ("\u{001B}[4m", "\u{001B}[24m")
    public static let strikethrough: TerminalStyleFormatCode   = ("\u{001B}[9m", "\u{001B}[29m")
    public static let reset: TerminalStyleFormatCode           = ("\u{001B}[0m", "")
}

extension String {
    public var localized: String {
        guard NSLocalizedString(self, comment: "") != self else {
            return self.replacingOccurrences(of: "\\n", with: "\n")
        }
        return NSLocalizedString(self, comment: "")
    }

    public func black() -> String {
        return applyStyle(TerminalStyleFormat.black)
    }
    public func white() -> String {
        return applyStyle(TerminalStyleFormat.white)
    }
    public func red() -> String {
        return applyStyle(TerminalStyleFormat.red)
    }
    public func green() -> String {
        return applyStyle(TerminalStyleFormat.green)
    }
    public func yellow() -> String {
        return applyStyle(TerminalStyleFormat.yellow)
    }
    public func blue() -> String {
        return applyStyle(TerminalStyleFormat.blue)
    }
    public func cyan() -> String {
        return applyStyle(TerminalStyleFormat.cyan)
    }
    public func lightGray() -> String {
        return applyStyle(TerminalStyleFormat.lightGray)
    }
    public func darkGray() -> String {
        return applyStyle(TerminalStyleFormat.darkGray)
    }
    public func bold() -> String {
        return applyStyle(TerminalStyleFormat.bold)
    }
    public func italic() -> String {
        return applyStyle(TerminalStyleFormat.italic)
    }
    public func underline() -> String {
        return applyStyle(TerminalStyleFormat.underline)
    }
    public func strikethrough() -> String {
        return applyStyle(TerminalStyleFormat.strikethrough)
    }
    public func reset() -> String {
        return  "\u{001B}[0m" + self
    }

    private func applyStyle(_ codeStyle: TerminalStyleFormatCode) -> String {
        let str = self.replacingOccurrences(of: TerminalStyleFormat.reset.start,
                                            with: TerminalStyleFormat.reset.start + codeStyle.start)
        return codeStyle.start + str + TerminalStyleFormat.reset.start
    }
}

extension String {
    public func linkAttributedString() -> NSMutableAttributedString {
        var stringToBeParsed = self
        let attrString = NSMutableAttributedString(string: stringToBeParsed)

        let occurrencies = self.components(separatedBy: "<link>").count - 1

        for _ in 1...occurrencies {
            let firstTagNSRange = NSRange(location: stringToBeParsed.distanceFromStart(of: "<link>")!,
                                          length: stringToBeParsed.distanceFromEnd(of: "<link>")!-stringToBeParsed.distanceFromStart(of: "<link>")!)
            let secondTagNSRange = NSRange(location: stringToBeParsed.distanceFromStart(of: "</link>")!,
                                           length: stringToBeParsed.distanceFromEnd(of: "</link>")!-stringToBeParsed.distanceFromStart(of: "</link>")!)
            let valueNSRange = NSRange(location: stringToBeParsed.distanceFromEnd(of: "<link>")!,
                                       length: stringToBeParsed.distanceFromStart(of: "</link>")!-stringToBeParsed.distanceFromEnd(of: "<link>")!)
            let firstTagRange = stringToBeParsed.range(of: "<link>")!
            let secondTagRange = stringToBeParsed.range(of: "</link>")!
            let valueRange = Range(uncheckedBounds: (lower: stringToBeParsed.range(of: "<link>")!.upperBound,
                                                     upper: stringToBeParsed.range(of: "</link>")!.lowerBound))

            guard firstTagRange.lowerBound < secondTagRange.lowerBound else { continue }

            attrString.addAttribute(NSAttributedString.Key.link,
                                    value: stringToBeParsed[valueRange], range: valueNSRange)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: NSColor.blue, range: valueNSRange)

            attrString.replaceCharacters(in: secondTagNSRange, with: "")
            attrString.replaceCharacters(in: firstTagNSRange, with: "")

            stringToBeParsed.removeSubrange(secondTagRange)
            stringToBeParsed.removeSubrange(firstTagRange)
        }

        return attrString
    }
}

extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distanceFromStart<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
    func distanceFromEnd<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.upperBound.distance(in: self) }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}
