#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias SceneTransition = Transition<NSWindowController, NSViewController>

#endif
