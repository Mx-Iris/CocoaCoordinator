import Foundation
///
/// `StrongRouter` is a type-erasure of a given Router object and, therefore, can be used as an abstraction from a specific Router
/// implementation without losing type information about its RouteType.
///
public final class StrongRouter<Route: Routable>: Router {
    private let _contextTrigger: (Route, TransitionOptions, ContextPresentationHandler?) -> Void

    public init<T: Router>(_ router: T) where T.Route == Route {
        _contextTrigger = router.contextTrigger
    }
    
    public func contextTrigger(_ route: Route, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        _contextTrigger(route, options, completion)
    }
}
