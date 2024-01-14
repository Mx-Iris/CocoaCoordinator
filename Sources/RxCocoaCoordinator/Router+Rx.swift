import RxSwift
import RxCocoa
import CocoaCoordinator

extension Reactive where Base: Router & AnyObject {
    public func trigger<Route: Routable>() -> Binder<Route> where Route == Base.Route {
        .init(base) { router, route in
            router.trigger(route)
        }
    }
    
    public func trigger<Route: Routable>(_ route: Route) -> Binder<Void> where Route == Base.Route {
        .init(base) { router, _ in
            router.trigger(route)
        }
    }
}

extension Router {

    /// Use this to access the reactive extensions of `Router` objects.
    public var rx: Reactive<Self> {
        // swiftlint:disable:previous identifier_name
        return Reactive(self)
    }
}
