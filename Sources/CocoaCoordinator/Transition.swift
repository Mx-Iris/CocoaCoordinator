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
