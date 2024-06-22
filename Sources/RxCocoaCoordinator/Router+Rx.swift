import RxSwift
import RxCocoa
import CocoaCoordinator

public class ReactiveRouter<Route: Routable> {
    // MARK: Stored Properties

    public let base: any Router<Route>

    // MARK: Initialization

    public init(_ base: any Router<Route>) {
        self.base = base
    }
}

extension Router {
    /// Use this to access the reactive extensions of `Router` objects.
    public var rx: ReactiveRouter<Route> {
        // swiftlint:disable:previous identifier_name
        ReactiveRouter(self)
    }
}

extension ReactiveRouter {
    public func trigger() -> Binder<Route> {
        .init(self) { router, route in
            Task {
                await MainActor.run {
                    router.base.trigger(route)
                }
            }
        }
    }
    
    public func trigger(_ route: Route) -> Binder<Void> {
        .init(self) { router, _ in
            Task {
                await MainActor.run {
                    router.base.trigger(route)
                }
            }
        }
    }
}
