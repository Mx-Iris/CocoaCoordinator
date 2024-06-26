#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public protocol TransitionContext {
    /// The presentables being shown to the user by the transition.
    var presentables: [Presentable] { get }
}

#endif
