//
//  SheetWindowManager.swift
//  CodeOrganizer
//
//  Created by JH on 2023/10/31.
//

import AppKit

final class SheetWindowManager: NSObject {
    public static let shared = SheetWindowManager()

    private var runningSheetWindows: [NSWindow: NSWindow] = [:]

    public func beginSheet(from fromWindow: NSWindow, to toWindow: NSWindow) {
        runningSheetWindows[fromWindow] = toWindow
        fromWindow.beginSheet(toWindow)
    }

    public func endSheet(from fromWindow: NSWindow) {
        guard let toWindow = runningSheetWindows[fromWindow] else { return }
        fromWindow.endSheet(toWindow)
    }
}
