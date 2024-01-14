import AppKit

public protocol Presentable {
    ///
    /// The viewController of the Presentable.
    ///
    /// In the case of a `UIViewController`, it returns itself.
    /// A coordinator returns its rootViewController.
    ///
    var viewController: NSViewController! { get }

    ///
    /// This method can be used to retrieve whether the presentable can trigger a specific route
    /// and potentially returns a router to trigger the route on.
    ///
    /// Deep linking makes use of this method to trigger the specified routes.
    ///
    /// - Parameter route:
    ///     The route to determine a router for.
    ///
    func router<R: Routable>(for route: R) -> StrongRouter<R>?

    ///
    /// This method is called whenever a Presentable is shown to the user.
    /// It further provides information about the context a presentable is shown in.
    ///
    /// - Parameter presentable:
    ///     The context in which the presentable is shown.
    ///     This could be a window, another viewController, a coordinator, etc.
    ///     `nil` is specified whenever a context cannot be easily determined.
    ///
    func presented(from presentable: Presentable?)

    ///
    /// This method is used to register a parent coordinator to a child coordinator.
    ///
    /// - Note:
    ///     This method is used internally and should never be called directly.
    ///
    func registerParent(_ presentable: Presentable & AnyObject)

    ///
    /// This method gets called when the transition of a child coordinator is being reported to its parent.
    ///
    /// - Note:
    ///     This method is used internally and should never be called directly.
    ///
    func childTransitionCompleted()

    ///
    /// Sets the presentable as the root of the window.
    ///
    /// This method sets the rootViewController of the window and makes it key and visible.
    /// Furthermore, it calls `presented(from:)` with the window as its parameter.
    ///
    /// - Parameter window:
    ///     The window to set the root of.
    ///
    func setRoot(for window: NSWindow)
}

extension Presentable {
    public func registerParent(_ presentable: Presentable & AnyObject) {}

    public func childTransitionCompleted() {}

    public func setRoot(for window: NSWindow) {
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        presented(from: window)
    }

    public func router<R: Routable>(for route: R) -> StrongRouter<R>? {
        return self as? StrongRouter<R>
    }

    public func presented(from presentable: Presentable?) {}
}

extension NSViewController: Presentable {}

extension NSWindow: Presentable {
    public var viewController: NSViewController! { contentViewController }
}

/// The completion handler for transitions.
public typealias PresentationHandler = () -> Void

public typealias ContextPresentationHandler = (TransitionContext) -> Void

extension Coordinating {
    func canBeRemovedAsChild() -> Bool {
        if let presentable = self as? Presentable {
            return presentable.canBeRemovedAsChild()
        } else {
            return false
        }
    }
}

extension Presentable {
    func canBeRemovedAsChild() -> Bool {
        guard !(self is NSViewController) else { return true }
        guard let viewController else { return true }
        return !viewController.isInViewHierarchy
            && viewController.children.allSatisfy { $0.canBeRemovedAsChild() }
    }
}

extension NSViewController {
    fileprivate var isInViewHierarchy: Bool {
        if isInViewHierarchy(on: NSApplication.shared.keyWindow) {
            return true
        }
        
        if isInViewHierarchy(on: NSApplication.shared.mainWindow) {
            return true
        }
        
        if isInViewHierarchy(on: NSApplication.shared.modalWindow) {
            return true
        }
        
        return presentingViewController != nil
            || presentedViewControllers?.isEmpty == false
            || parent != nil
            || view.window != nil
        
    }
    
    func isInViewHierarchy(on window: NSWindow?) -> Bool {
        guard let window else { return false }
        return window.contentViewController === self
    }
}
