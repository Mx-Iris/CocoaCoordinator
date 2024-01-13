#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public protocol TransitionProtocol: TransitionContext {
    associatedtype W
    associatedtype V
    func perform(on windowController: W?, in viewController: V?, with options: TransitionOptions, completion: PresentationHandler?)
}


#endif
