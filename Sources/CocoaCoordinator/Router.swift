import Foundation

//
// `Router` is used to abstract the transition-type that can be able to perform route from its `Coordinator`.
//

public protocol Router<Route>: AnyObject {
    associatedtype Route: Routable
    func contextTrigger(_ route: Route, with options: TransitionOptions, completion: ContextPresentationHandler?)
}

extension Router {
    @available(*, deprecated, message: "use any Router<Route>")
    public var strongRouter: StrongRouter<Route> {
        return StrongRouter(self)
    }
}

extension Router {
    @available(*, deprecated, message: "use unowned let router: any Router<Route>")
    public var unownedRouter: UnownedRouter<Route> {
        return UnownedRouter(self) { $0.strongRouter }
    }
}

extension Router {
    public func trigger(_ route: Route) {
        trigger(route, with: .default, completion: nil)
    }

    // MARK: Convenience methods

    ///
    /// Triggers the specified route without the need of specifying a completion handler.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options:
    ///         Transition options for performing the transition, e.g. whether it should be animated.
    ///
    public func trigger(_ route: Route, with options: TransitionOptions) {
        trigger(route, with: options, completion: nil)
    }

    ///
    /// Triggers the specified route with default transition options enabling the animation of the transition.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///
    public func trigger(_ route: Route, completion: PresentationHandler? = nil) {
        trigger(route, with: .default, completion: completion)
    }

    ///
    /// Triggers the specified route by performing a transition.
    ///
    /// - Parameters:
    ///     - route: The route to be triggered.
    ///     - options: Transition options for performing the transition, e.g. whether it should be animated.
    ///     - completion:
    ///         If present, this completion handler is executed once the transition is completed
    ///         (including animations).
    ///
    public func trigger(_ route: Route, with options: TransitionOptions, completion: PresentationHandler?) {
        contextTrigger(route, with: options) { _ in completion?() }
    }
}

extension Router where Self: Presentable {
    // MARK: Computed properties

    ///
    /// Creates a StrongRouter object from the given router to abstract from concrete implementations
    /// while maintaining information necessary to fulfill the Router protocol.
    /// The original router will be held strongly.
    ///
//    public var strongRouter: StrongRouter<Route> {
//        return StrongRouter(self)
//    }

    ///
    /// Returns a router for the specified route, if possible.
    ///
    /// - Parameter route:
    ///     The route type to return a router for.
    ///
    /// - Returns:
    ///     It returns the router's strongRouter,
    ///     if it is compatible with the given route type,
    ///     otherwise `nil`.
    ///
//    public func router<R: Routable>(for route: R) -> (any Router<R>)? {
//        return self
//    }
}
