//
//  SceneCoordinator.swift
//
//
//  Created by JH on 2024/1/12.
//

import AppKit

open class SceneCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: ViewCoordinator<RouteType, TransitionType> where TransitionType.W: NSWindowController, TransitionType.V: NSViewController {
    
    public let windowController: TransitionType.W
    
    public init(windowController: TransitionType.W, rootViewController: TransitionType.V, initialRoute: RouteType?) {
        self.windowController = windowController
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }

    open override func performTransition(_ transition: TransitionType, with options: TransitionOptions = .default, completion: PresentationHandler? = nil) {
        transition.presentables.compactMap { $0 as? (any Coordinating) }.forEach(addChild(_:))
        transition.perform(on: windowController, in: rootViewController, with: options) {
            completion?()
            self.removeChildrenIfNeeded()
        }
    }
}
