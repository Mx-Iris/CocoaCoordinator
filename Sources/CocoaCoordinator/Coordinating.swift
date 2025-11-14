//
// `Coordinating` is the protocol every coordinator conforms to.
//
// It requires an object to be able to add, remove its child and can be removed themselves from parent like `removeFromSuperview`.
//


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


public protocol TransitionPerformer<Transition> {
    /// The type of transitions that can be executed on the rootViewController.
    associatedtype Transition: TransitionProtocol

    ///
    /// Perform a transition.
    ///
    /// - Warning:
    ///     Do not use this method directly, but instead try to use the `trigger`
    ///     method of your coordinator instead wherever possible.
    ///
    /// - Parameters:
    ///     - transition: The transition to be performed.
    ///     - options: The options on how to perform the transition, including the option to enable/disable animations.
    ///     - completion: The completion handler called once a transition has finished.
    ///
    func performTransition(_ transition: Transition, with options: TransitionOptions, completion: PresentationHandler?)
}
