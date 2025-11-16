import AppKit
import OSLog

private let logger = Logger(subsystem: "com.MxIris.CocoaCoordinator", category: "Coordinator")

open class Coordinator<Route: Routable, Transition: TransitionProtocol>: NSResponder, Coordinating {
    public private(set) weak var parent: (any Coordinating)?

    public private(set) var children: [any Coordinating] = []

    package var didCompleteTransition: (Route) -> Void = { _ in }

    public var identifer: String {
        String(describing: Self.self)
    }

    public init(initialRoute: Route?) {
        super.init()
        initialRoute.map { prepareTransition(for: $0) }.map { performTransition($0) }
        initialRoute.map { completeTransition(for: $0) }
    }

    public init(initialTranstion: Transition?) {
        super.init()
        initialTranstion.map { performTransition($0) }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func removeFromParent() {
        parent?.removeChild(self)
    }

    public func addChild(_ coordinator: any Coordinating) {
        children.append(coordinator)
        coordinator.registerParent(self)
    }

    public func registerParent(_ coordinator: any Coordinating) {
        parent = coordinator
    }

    public func removeChild(_ coordinator: any Coordinating) {
        if let index = children.firstIndex(where: { $0.identifer == coordinator.identifer }) {
            let child = children[index]
            child.removeAllChild()
            children.remove(at: index)
        } else {
            logger.warning("Couldn't remove coordinator: \(String(describing: coordinator)). It's not a child coordinator.")
        }
    }

    public func removeAllChild<T>(with type: T.Type) {
        children.removeAll(where: { $0 is T })
    }

    public func removeAllChild() {
        children.forEach { $0.removeAllChild() }
        children.removeAll()
    }

    public func removeChildrenIfNeeded() {
        children.removeAll { $0.canBeRemovedAsChild() }
    }

    deinit {
        logger.debug("Deinit 📣: \(String(describing: self))")
    }

    open func contextTrigger(_ route: Route, with options: TransitionOptions = .default, completion: ContextPresentationHandler? = nil) {
        let transition = prepareTransition(for: route)
        performTransition(transition, with: options) { [weak self] in
            guard let self else { return }
            completion?(transition)
            completeTransition(for: route)
        }
    }

    open func prepareTransition(for route: Route) -> Transition {
        fatalError("Please override the \(#function) method.")
    }

    open func performTransition(_ transition: Transition, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        transition.perform(on: nil, in: nil, with: options) {
            completion?()
        }
    }

    open func completeTransition(for route: Route) {
        didCompleteTransition(route)
    }
}
