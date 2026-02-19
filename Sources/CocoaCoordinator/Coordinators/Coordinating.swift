//
// `Coordinating` is the protocol every coordinator conforms to.
//
// It requires an object to be able to add, remove its child and can be removed themselves from parent like `removeFromSuperview`.
//

@MainActor
public protocol Coordinating<Route, Transition>: Router, TransitionPerformer {
    var identifer: String { get }
    var parent: (any Coordinating)? { get }
    var children: [any Coordinating] { get }
    func addChild(_ coordinator: any Coordinating)
    func removeChild(_ coordinator: any Coordinating)
    func removeAllChild<T>(with type: T.Type)
    func removeAllChild()
    func removeFromParent()
    func registerParent(_ coordinator: any Coordinating)
    func prepareTransition(for route: Route) -> Transition
    func completeTransition(for route: Route)
}



