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
