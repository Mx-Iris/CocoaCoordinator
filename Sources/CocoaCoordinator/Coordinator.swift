import Foundation

open class Coordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinating {
    public private(set) var parent: (any Coordinating)?
    public private(set) var children: [any Coordinating] = []
    public var identifer: String {
        String(describing: Self.self)
    }

    public init(initialRoute: RouteType?) {
        initialRoute.map { prepareTransition(for: $0) }.map { performTransition($0) }
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        fatalError("Please override the \(#function) method.")
    }

    public func removeFromParent() {
        parent?.removeChild(self)
    }

    public func addChild(_ coordinator: any Coordinating) {
        children.append(coordinator)
        coordinator.registerParent(self)
    }

    public func registerParent(_ coordinator: any Coordinating & AnyObject) {
        parent = coordinator
    }

    public func removeChild(_ coordinator: any Coordinating) {
        if let index = children.firstIndex(where: { $0.identifer == coordinator.identifer }) {
            let child = children[index]
            child.removeAllChild()
            children.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
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
        debugPrint("Deinit 📣: \(String(describing: self))")
    }

    open func contextTrigger(_ route: RouteType, with options: TransitionOptions = .default, completion: ContextPresentationHandler? = nil) {
        let transition = prepareTransition(for: route)
        performTransition(transition, with: options) {
            completion?(transition)
            self.completeTransition(route)
        }
    }
    
    
    
    open func performTransition(_ transition: TransitionType, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: nil, in: nil, with: options) {
            completion?()
//            self.removeChildrenIfNeeded()
        }
    }
    
    open func completeTransition(_ route: RouteType) {}
}

