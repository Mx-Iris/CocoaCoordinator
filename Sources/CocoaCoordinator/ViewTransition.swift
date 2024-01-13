#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias ViewTransition = Transition<Void, NSViewController>

#endif
