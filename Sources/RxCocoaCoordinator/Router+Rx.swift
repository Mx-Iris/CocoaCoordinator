import RxSwift
import RxCocoa
import CocoaCoordinator

public struct ReactiveRouter<Route: Routable> {
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
    public func trigger() -> AnyObserver<Route> {
        AnyObserver<Route> { [weak base] event in
            guard let base else { return }
            switch event {
            case let .next(route):
                base.trigger(route)
            default:
                break
            }
        }
    }

    public func trigger(_ route: Route) -> AnyObserver<Void> {
        AnyObserver<Void> { [weak base] event in
            guard let base else { return }
            switch event {
            case .next:
                base.trigger(route)
            default:
                break
            }
        }
    }
}
