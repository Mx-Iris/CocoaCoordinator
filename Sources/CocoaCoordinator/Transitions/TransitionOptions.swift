#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public struct TransitionOptions {
    // MARK: Stored properties

    /// Specifies whether or not the transition should be animated.
    public let animated: Bool

    // MARK: Initialization

    ///
    /// Creates transition options on the basis of whether or not it should be animated.
    ///
    /// - Note:
    ///     Specifying `true` to enable animations does not necessarily lead to an animated transition,
    ///     if the transition does not support it.
    ///
    /// - Parameter animated:
    ///     Whether or not the animation should be animated.
    ///
    public init(animated: Bool) {
        self.animated = animated
    }

    // MARK: Static computed properties

    public static var `default`: TransitionOptions {
        return TransitionOptions(animated: true)
    }
}

#endif
