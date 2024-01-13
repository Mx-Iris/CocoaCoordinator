#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias SceneTransition<V: NSViewController> = Transition<NSWindowController, V>

#endif
