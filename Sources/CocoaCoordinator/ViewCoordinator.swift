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
open class ViewCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator<RouteType, TransitionType>, Presentable where TransitionType.V: NSViewController {
    public var rootViewController: TransitionType.V

    public init(rootViewController: TransitionType.V, initialRoute: RouteType?) {
        self.rootViewController = rootViewController
        super.init(initialRoute: initialRoute)
    }

    public var viewController: NSViewController! {
        return rootViewController
    }
    
    open override func performTransition(_ transition: TransitionType, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: nil, in: rootViewController, with: options) {
            completion?()
            self.removeChildrenIfNeeded()
        }
    }
    
    
}
