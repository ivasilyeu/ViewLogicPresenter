//
//  RouterController+NavigationBarPreferencesDelegate.swift
//
//  Created by IV on 13.11.2020.
//

import UIKit

// MARK: - NavigationBarPreferencesDelegate

/**
 For the case when the RouterController manages (contains) its own UINavigationController, it can provide a NavigationBarPreferencesDelegate to handle the navigation bar preferences changes after push and pop transitions
 */
extension RouterController: NavigationBarPreferencesDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNeedsNavigationBarPreferencesUpdate(for: viewController)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        /// point of override
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        nil /// point of override
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil /// point of override
    }

    // MARK:

    var defaultNavigationDelegate: NavigationBarPreferencesDelegate { self }
}
