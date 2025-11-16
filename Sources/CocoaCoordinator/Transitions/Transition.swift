import AppKit

public struct Transition<WindowController, ViewController>: TransitionProtocol {
    public typealias PerformClosure = (
        _ windowController: WindowController?,
        _ viewController: ViewController?,
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

    public func perform(on windowController: WindowController?, in viewController: ViewController?, with options: TransitionOptions, completion: PresentationHandler?) {
        autoreleasepool {
            _perform(windowController, viewController, options, completion)
        }
    }
}
