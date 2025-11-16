#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension NSViewController {
    public enum PresentationMode {
        case asModalWindow
        case asSheet
        case asPopover(relativeToRect: NSRect, ofView: NSView, preferredEdge: NSRectEdge, behavior: NSPopover.Behavior)
        case transition(options: NSViewController.TransitionOptions)
        case animator(animator: NSViewControllerPresentationAnimator)
    }

    private var topPresentedViewController: NSViewController {
        guard let presentedViewControllers else { return self }
        for presentedViewController in presentedViewControllers {
            return presentedViewController.topPresentedViewController
        }
        return self
    }

    public func present(onRoot: Bool, _ viewController: NSViewController?, mode: PresentationMode, completion: PresentationHandler?) {
        guard let viewController else {
            completion?()
            return
        }
        let presentingViewController = onRoot ? self : topPresentedViewController
        switch mode {
        case .asSheet:
            presentingViewController.presentAsSheet(viewController)
        case .asModalWindow:
            presentingViewController.presentAsModalWindow(viewController)
        case let .asPopover(positioningRect, positioningView, preferredEdge, behavior):
            presentingViewController.present(viewController, asPopoverRelativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge, behavior: behavior)
        case let .transition(options):
            presentingViewController.transition(from: self, to: viewController, options: options, completionHandler: completion)
            return
        case let .animator(animator):
            presentingViewController.present(viewController, animator: animator)
        }
        completion?()
    }

    public func dismiss(toRoot: Bool, completion: PresentationHandler?) {
        let presentedViewController = topPresentedViewController
        let dismissalViewController = toRoot ? self : presentedViewController
        dismissalViewController.dismiss(nil)
        completion?()
    }
}

#endif
