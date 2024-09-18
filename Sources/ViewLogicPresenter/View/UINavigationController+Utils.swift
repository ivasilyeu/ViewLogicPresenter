//
//  UIViewController+Containering.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

extension UINavigationController {

    /**
     - Returns `AnyObject` that is either an instance of `UIViewController` of the specified concrete type, or `nil` if such
     view controller doesn't exist in the navigation stack. Returns the topmost view controller of the specified type.

     - Note: `AnyObject` is used as the return type to avoid the need of type casting on the caller side, which would be necessary in case `UIViewController` was used as the return type
     */
    @objc
    func topViewControllerOfType(_ type: AnyClass) -> AnyObject? {
        viewControllers.last { $0.isKind(of: type) }
    }

    /**
     Swift version of ``topViewControllerOfType(_ type:)``
     */
    func topViewControllerOf<T>(_ type: T.Type = T.self) -> T? where T: UIViewController {
        viewControllers.last { $0 is T } as? T
    }
}

// MARK: -

extension UINavigationController {

    /**
     Navigates to the target view controller, represented by the generic parameter, either by creating it and pushing to the stack, or popping to an existing instance of it, if present.

     - Parameter type: A metatype of UIViewController which is the navigation target. This must be required, to work around Swift type inferring issue that lead to invalid assumption that T is always UIViewController.self, regardless of the return value of the `constructor` closure.
     */
    @discardableResult
    func navigateToController<T>(_ type: T.Type, animated: Bool = true, constructor: () -> T) -> T where T: UIViewController {

        let result: T
        let existingController = topViewControllerOf(T.self)

        if let existingController = existingController {
            popToViewController(existingController, animated: animated)
            result = existingController
        }
        else {
            let controller = constructor()
            pushViewController(controller, animated: animated)
            result = controller
        }

        return result
    }

    /**
     Navigates to the target view controller, represented by the constructor, either by creating it and pushing to the stack, or popping to an existing instance of it, if present.
     */
    @objc
    @discardableResult
    func navigateToControllerOfType(_ controllerType: AnyClass, animated: Bool, withConstructor constructor: (() -> UIViewController)) -> UIViewController
    {
        let result: UIViewController
        let existingController = topViewControllerOfType(controllerType) as? UIViewController

        if let existingController = existingController {
            popToViewController(existingController, animated: animated)
            result = existingController
        }
        else {
            let controller = constructor()
            pushViewController(controller, animated: animated)
            result = controller
        }

        return result
    }

    /**
     Pops view controllers until the one specified, including, ie until a controller preceeding the one specified is on top. Returns the popped controllers.
     */
    @objc
    @discardableResult
    func popViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {

        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
            return [] // cannot find the specified view controller in the stack
        }

        guard viewControllerIndex > viewControllers.startIndex else {
            return [] // the specified view controller is the root one - it cannot be popped
        }

        let targetIndex = viewControllers.index(before: viewControllerIndex)
        let targetViewController = viewControllers[targetIndex]
        return popToViewController(targetViewController, animated: animated)
    }
}
