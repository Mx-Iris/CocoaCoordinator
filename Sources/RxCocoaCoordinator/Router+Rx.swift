import RxSwift
import RxCocoa
import CocoaCoordinator
import Foundation

@MainActor
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
            Task { @MainActor in
                guard let base else { return }
                switch event {
                case let .next(route):
                    base.trigger(route)
                default:
                    break
                }
            }
        }
    }

    public func trigger(_ route: Route) -> AnyObserver<Void> {
        AnyObserver<Void> { [weak base] event in
            Task { @MainActor in
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
}

@MainActor
public struct ReactiveCoordinator<Route: Routable, Transition: TransitionProtocol> {
    public let base: Coordinator<Route, Transition>

    public init(_ base: Coordinator<Route, Transition>) {
        self.base = base
    }
}

extension Coordinator {
    public var rx: ReactiveCoordinator<Route, Transition> {
        ReactiveCoordinator(self)
    }
}

extension Coordinator {
    fileprivate var _didCompleteTransitionRelay: PublishRelay<Route> {
        if let relay = objc_getAssociatedObject(self, #function) as? PublishRelay<Route> {
            return relay
        }
        let relay = PublishRelay<Route>()
        let prevCompleteTransition = didCompleteTransition
        didCompleteTransition = {
            prevCompleteTransition($0)
            relay.accept($0)
        }
        objc_setAssociatedObject(self, #function, relay, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return relay
    }
}

extension ReactiveCoordinator {
    public func didCompleteTransition() -> Observable<Route> {
        base._didCompleteTransitionRelay.asObservable()
    }
}
