import AppKit

@MainActor
public struct Transition<WindowController, ViewController>: TransitionProtocol {
    public typealias PerformClosure = @MainActor @Sendable (
        _ windowController: WindowController?,
        _ viewController: ViewController?,
        _ options: TransitionOptions,
        _ completion: PresentationHandler?
    ) -> Void

    // MARK: Stored properties

    private let _perform: PerformClosure

    private let _presentables: [Presentable]

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
