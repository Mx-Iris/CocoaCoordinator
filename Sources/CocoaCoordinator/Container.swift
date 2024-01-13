import AppKit

///
/// Container abstracts away from the difference of `NSView` and `NSViewController`
///
/// With the Container protocol, `NSView` and `NSViewController` objects can be used interchangeably,
/// e.g. when embedding containers into containers.
///
public protocol Container {

    ///
    /// The view of the Container.
    ///
    /// - Note:
    ///     It might not exist for a `NSViewController`.
    ///
    var view: NSView { get }

    ///
    /// The viewController of the Container.
    ///
    /// - Note:
    ///     It might not exist for a `NSView`.
    ///
    var viewController: NSViewController! { get }
}

// MARK: - Extensions

extension NSViewController: Container {
    public var viewController: NSViewController! { return self }
}

extension NSView: Container {
    public var viewController: NSViewController! {
        return viewController(for: self)
    }

    public var view: NSView { return self }
}

extension NSView {
    private func viewController(for responder: NSResponder) -> NSViewController? {
        if let viewController = responder as? NSViewController {
            return viewController
        }

        if let nextResponser = responder.nextResponder {
            return viewController(for: nextResponser)
        }

        return nil
    }
}
