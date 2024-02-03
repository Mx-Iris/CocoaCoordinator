#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public protocol TransitionProtocol: TransitionContext {
    associatedtype W
    associatedtype V
    func perform(on windowController: W?, in viewController: V?, with options: TransitionOptions, completion: PresentationHandler?)
    static func multiple(_ transitions: [Self]) -> Self
}

extension TransitionProtocol {

    ///
    /// Creates a compound transition by chaining multiple transitions together.
    ///
    /// - Parameter transitions:
    ///     The transitions to be chained to form a combined transition.
    ///
    public static func multiple(_ transitions: Self...) -> Self {
        return multiple(transitions)
    }

}

#endif
