import AppKit


public typealias AppTransition = Transition<Void, Void>

public struct Transition<W, V>: TransitionProtocol {
    public typealias PerformClosure = (
        _ windowController: W?,
        _ viewController: V?,
        _ options: TransitionOptions,
        _ completion: PresentationHandler?
    ) -> Void

    // MARK: Stored properties

    private var _perform: PerformClosure

    private var _presentables: [Presentable]

    public var presentables: [Presentable] {
        return _presentables
    }

    public init(presentables: [Presentable], perform: @escaping PerformClosure) {
        self._presentables = presentables
        self._perform = perform
    }

    public func perform(on windowController: W?, in viewController: V?, with options: TransitionOptions, completion: PresentationHandler?) {
        autoreleasepool {
            _perform(windowController, viewController, options, completion)
        }
    }
}

public struct TransitionOptions {
    // MARK: Stored properties

    /// Specifies whether or not the transition should be animated.
    public let animated: Bool

    // MARK: Initialization

    ///
    /// Creates transition options on the basis of whether or not it should be animated.
    ///
    /// - Note:
    ///     Specifying `true` to enable animations does not necessarily lead to an animated transition,
    ///     if the transition does not support it.
    ///
    /// - Parameter animated:
    ///     Whether or not the animation should be animated.
    ///
    public init(animated: Bool) {
        self.animated = animated
    }

    // MARK: Static computed properties

    public static var `default`: TransitionOptions {
        return TransitionOptions(animated: true)
    }
}

public protocol TransitionContext {
    /// The presentables being shown to the user by the transition.
    var presentables: [Presentable] { get }
}
