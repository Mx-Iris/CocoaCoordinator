//
//  ViewCoordinator.swift
//  ModernCoordinator
//
//  Created by DucPD on 11/11/2021.
//

import AppKit

///
/// `ViewCoordinator` is a base class for custom coordinators with a `UIViewController` as `rootViewController`.
///
open class ViewCoordinator<Route: Routable, Transition: TransitionProtocol>: Coordinator<Route, Transition>, Presentable where Transition.V: NSViewController {
    public var rootViewController: Transition.V

    public init(rootViewController: Transition.V, initialRoute: Route?) {
        self.rootViewController = rootViewController
        super.init(initialRoute: initialRoute)
    }

    public init(rootViewController: Transition.V, initialTranstion: Transition?) {
        self.rootViewController = rootViewController
        super.init(initialTranstion: initialTranstion)
    }
    
    public var viewController: NSViewController! {
        return rootViewController
    }

    open override func performTransition(_ transition: Transition, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: nil, in: rootViewController, with: options) {
            completion?()
        }
    }
}
