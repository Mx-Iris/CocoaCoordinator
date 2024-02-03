#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias ViewTransition<V: NSViewController> = Transition<Void, V>

public typealias BasicViewTransition = ViewTransition<NSViewController>

#endif
