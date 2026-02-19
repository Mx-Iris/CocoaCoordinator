#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

@MainActor
public protocol TransitionProtocol: TransitionContext {
    associatedtype WindowController
    associatedtype ViewController
    func perform(on windowController: WindowController?, in viewController: ViewController?, with options: TransitionOptions, completion: PresentationHandler?)
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
