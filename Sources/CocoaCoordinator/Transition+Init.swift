#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension Transition where V: NSSplitViewController {
    public static func set(_ presentables: [Presentable]) -> Self {
        Self(presentables: presentables) { windowController, viewController, options, completion in
            viewController?.splitViewItems.forEach { viewController?.removeSplitViewItem($0) }
            presentables.forEach { viewController?.addSplitViewItem(NSSplitViewItem(viewController: $0.viewController)) }
        }
    }
    
    @available(macOS 11, *)
    public static func set(sidebar: Presentable, content: Presentable, inspector: Presentable) -> Self {
        Self(presentables: [sidebar, content, inspector]) { windowController, viewController, options, completion in
            viewController?.splitViewItems.forEach { viewController?.removeSplitViewItem($0) }
            viewController?.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: sidebar.viewController))
            viewController?.addSplitViewItem(NSSplitViewItem(contentListWithViewController: content.viewController))
            viewController?.addSplitViewItem(NSSplitViewItem(inspectorWithViewController: inspector.viewController))
        }
    }
}

extension Transition where V: NSTabViewController {
    public static func set(_ presentables: [Presentable]) -> Self {
        Self(presentables: presentables) { windowController, viewController, options, completion in
            viewController?.tabViewItems.forEach { viewController?.removeTabViewItem($0) }
            presentables.forEach { viewController?.addTabViewItem(NSTabViewItem(viewController: $0.viewController)) }
        }
    }
}

extension Transition where V: NSViewController {
    public static func presentOnRoot(_ presentable: Presentable, mode: NSViewController.PresentationMode) -> Self {
        Self(presentables: [presentable]) { _, vc, _, completion in
            vc?.present(onRoot: true, presentable.viewController, mode: mode) {
                presentable.presented(from: vc)
                completion?()
            }
        }
    }

    public static func present(_ presentable: Presentable, mode: NSViewController.PresentationMode) -> Self {
        Self(presentables: [presentable]) { _, vc, _, completion in
            vc?.present(onRoot: false, presentable.viewController, mode: mode) {
                presentable.presented(from: vc)
                completion?()
            }
        }
    }

    public static func dismissToRoot() -> Self {
        Self(presentables: []) { _, vc, _, completion in vc?.dismiss(toRoot: true, completion: completion) }
    }

    public static func dismiss() -> Self {
        Self(presentables: []) { _, vc, _, completion in vc?.dismiss(toRoot: false, completion: completion) }
    }
}

extension Transition where W: NSWindowController {
    public static func show() -> Self {
        Self(presentables: []) { wc, _, _, completion in
            wc?.showWindow(nil)
            completion?()
        }
    }

    public static func show(_ presentable: Presentable) -> Self {
        Self(presentables: [presentable]) { wc, _, _, completion in
            wc?.contentViewController = presentable.viewController
            wc?.showWindow(nil)
            completion?()
        }
    }

    public static func close() -> Self {
        Self(presentables: []) { wc, vc, _, completion in
            wc?.close()
            completion?()
        }
    }

    public static func beginSheet(_ presentable: Presentable) -> Self {
        Self(presentables: [presentable]) { wc, _, _, completion in wc?.window?.beginSheet(NSWindow(contentViewController: presentable.viewController)) { _ in
            completion?()
        }
        }
    }

    public static func endSheetOnTop() -> Self {
        Self(presentables: []) { wc, _, _, completion in
            guard let attachedSheet = wc?.window?.attachedSheet else { return }
            wc?.window?.endSheet(attachedSheet)
            completion?()
        }
    }
}

extension Transition {
    public static func beginModal(_ presentable: Presentable) -> Self {
        Self(presentables: [presentable]) { _, _, _, completion in
            ModalWindowManager.shared.beginModalSession(for: presentable.viewController)
            completion?()
        }
    }

    public static func endModal() -> Self {
        Self(presentables: []) { _, _, _, completion in
            ModalWindowManager.shared.endModalSession()
            completion?()
        }
    }

    public static func popover(_ presentable: Presentable, relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Self {
        Self(presentables: [presentable]) { _, _, _, completion in
            GlobalPopover.shared.show(viewController: presentable.viewController, relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
            completion?()
        }
    }

    public static func none() -> Self {
        Self(presentables: []) { _, _, _, completion in
            completion?()
        }
    }

    public static func multiple<C: Collection>(_ transitions: C) -> Self where C.Element == Transition {
        return Self(presentables: transitions.flatMap { $0.presentables }) { wc, vc, options, completion in
            guard let firstTransition = transitions.first else {
                completion?()
                return
            }
            firstTransition.perform(on: wc, in: vc, with: options) {
                let newTransitions = Array(transitions.dropFirst())
                Transition
                    .multiple(newTransitions)
                    .perform(on: wc, in: vc, with: options, completion: completion)
            }
        }
    }

    public static func route<C: Coordinating>(_ route: C.Route, on coordinator: C) -> Self {
        let transition = coordinator.prepareTransition(for: route)
        return Transition(presentables: transition.presentables
        ) { _, _, options, completion in
            coordinator.performTransition(transition, with: options, completion: completion)
        }
    }
}

#endif
