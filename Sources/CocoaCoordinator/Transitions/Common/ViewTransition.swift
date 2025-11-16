#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias ViewTransition<ViewController: NSViewController> = Transition<Void, ViewController>

public typealias BasicViewTransition = ViewTransition<NSViewController>

#endif
