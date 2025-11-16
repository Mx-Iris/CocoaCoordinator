import AppKit

open class ViewCoordinator<Route: Routable, Transition: TransitionProtocol>: Coordinator<Route, Transition>, Presentable where Transition.V: NSViewController {
    public var rootViewController: Transition.V

    public init(rootViewController: Transition.V, initialRoute: Route?) {
        self.rootViewController = rootViewController
        super.init(initialRoute: initialRoute)
    }

    public init(rootViewController: Transition.V, initialTranstion: Transition?) {
        self.rootViewController = rootViewController
        super.init(initialTranstion: initialTranstion)
    }

    public var viewController: NSViewController? {
        return rootViewController
    }

    open override func performTransition(_ transition: Transition, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        setupNextResponder()
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: nil, in: rootViewController, with: options) {
            completion?()
        }
    }

    public func router<R>(for route: R) -> (any Router<R>)? where R: Routable {
        self as? ViewCoordinator<R, Transition>
    }

    open func setupNextResponder() {
        let originalNextResponder = rootViewController.nextResponder
        nextResponder = originalNextResponder
        rootViewController.nextResponder = self
    }
}
