import AppKit

public final class WindowDelegate: NSObject, NSWindowDelegate {
    public var windowWillClose: () -> Void = {}

    public func windowWillClose(_ notification: Notification) {
        windowWillClose()
    }
}

@MainActor
open class SceneCoordinator<Route: Routable, Transition: TransitionProtocol>: ViewCoordinator<Route, Transition> where Transition.W: NSWindowController, Transition.V: NSViewController {
    public let windowController: Transition.W

    public let windowDelegate: WindowDelegate

    public init(windowController: Transition.W, rootViewController: Transition.V, initialRoute: Route?) {
        self.windowController = windowController
        self.windowDelegate = .init()
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }

    public init(windowController: Transition.W, rootViewController: Transition.V, initialTranstion: Transition?) {
        self.windowController = windowController
        self.windowDelegate = .init()
        super.init(rootViewController: rootViewController, initialTranstion: initialTranstion)
    }
    
    open override func performTransition(_ transition: Transition, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: windowController, in: rootViewController, with: options) {
            completion?()
        }
    }

    open func setupWindowDelegate() {
        windowController.window?.delegate = windowDelegate
    }
}
