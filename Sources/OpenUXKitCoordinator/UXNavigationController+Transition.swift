#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit
import OpenUXKit
import CocoaCoordinator

extension UXNavigationController {
    func push(_ viewController: UXViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        autoreleasepool {
            pushViewController(viewController, animated: animated)
        }
        CATransaction.commit()
    }

    func pop(toRoot: Bool, animated: Bool, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            if toRoot {
                popToRootViewController(animated: animated)
            } else {
                popViewController(animated: animated)
            }
        }

        CATransaction.commit()
    }

    func set(_ viewControllers: [UXViewController], animated: Bool, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }

        autoreleasepool {
            setViewControllers(viewControllers, animated: animated)
        }

        CATransaction.commit()
    }

    func pop(to viewController: UXViewController, animated: Bool, completion: PresentationHandler?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        autoreleasepool {
            _ = popToViewController(viewController, animated: animated)
        }

        CATransaction.commit()
    }
}

#endif
