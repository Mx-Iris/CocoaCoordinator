//
//  StrongRouter.swift
//  ModernCoordinator
//
//  Created by DucPD on 08/11/2021.
//

import Foundation
///
/// `StrongRouter` is a type-erasure of a given Router object and, therefore, can be used as an abstraction from a specific Router
/// implementation without losing type information about its RouteType.
///
public final class StrongRouter<RouteType: Route>: Router {
    private let _contextTrigger: (RouteType, TransitionOptions, ContextPresentationHandler?) -> Void

    public init<T: Router>(_ router: T) where T.RouteType == RouteType {
        _contextTrigger = router.contextTrigger
    }
    
    public func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        _contextTrigger(route, options, completion)
    }
}
