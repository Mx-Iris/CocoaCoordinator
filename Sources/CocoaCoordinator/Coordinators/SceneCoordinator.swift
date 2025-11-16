import AppKit

open class SceneCoordinator<Route: Routable, Transition: TransitionProtocol>: Coordinator<Route, Transition> where Transition.WindowController: NSWindowController, Transition.ViewController: NSViewController {
    public let windowController: Transition.WindowController

    public init(windowController: Transition.WindowController, initialRoute: Route?) {
        self.windowController = windowController
        super.init(initialRoute: initialRoute)
    }

    public init(windowController: Transition.WindowController, initialTranstion: Transition?) {
        self.windowController = windowController
        super.init(initialTranstion: initialTranstion)
    }

    open override func performTransition(_ transition: Transition, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        setupNextResponder()
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: windowController, in: windowController.contentViewController as? Transition.ViewController, with: options) {
            completion?()
        }
    }
    
    open func setupNextResponder() {
        let originalNextResponder = windowController.nextResponder
        
        if originalNextResponder != self {
            nextResponder = originalNextResponder
        }
        if windowController.nextResponder != self {
            windowController.nextResponder = self
        }
    }
}
