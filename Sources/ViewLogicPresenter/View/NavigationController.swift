//
//  NavigationController.swift
//  IV
//
//  Created by IV on 01.02.2022.
//  Copyright © 2022 IV. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        topViewController ?? super.childForStatusBarStyle
    }

    override var childForStatusBarHidden: UIViewController? {
        topViewController ?? super.childForStatusBarHidden
    }

    override var childForModalPresentationStatusBarAppearance: UIViewController? {
        topViewController ?? super.childForModalPresentationStatusBarAppearance
    }

    override var childForModalPresentationStyle: UIViewController? {
        topViewController ?? super.childForModalPresentationStyle
    }

    override var childForHomeIndicatorAutoHidden: UIViewController? {
        topViewController ?? super.childForHomeIndicatorAutoHidden
    }

    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        topViewController ?? super.childForScreenEdgesDeferringSystemGestures
    }

    override var childViewControllerForPointerLock: UIViewController? {
        topViewController ?? super.childViewControllerForPointerLock
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        handleNavigationStackChange()
    }

    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        let result = super.popViewController(animated: animated)
        handleNavigationStackChange()
        return result
    }

    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let result = super.popToViewController(viewController, animated: animated)
        handleNavigationStackChange()
        return result
    }

    @discardableResult
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let result = super.popToRootViewController(animated: animated)
        handleNavigationStackChange()
        return result
    }

    override var viewControllers: [UIViewController] {
        didSet {
            handleNavigationStackChange()
        }
    }

    private func handleNavigationStackChange() {
        updateMultitabBarIfNeeded()
        setNeedsUpdateExternalPreferences()
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        updateMultitabBarIfNeeded()
    }

    private func updateMultitabBarIfNeeded() {

        guard let topViewController, let multitabBarController else { return }

        let shouldHide = topViewController.hidesBottomBarWhenPushed
        multitabBarController.setTabBarHidden(shouldHide, animated: true)
    }

    private func setNeedsUpdateExternalPreferences() {

        setNeedsStatusBarAppearanceUpdate()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        setNeedsUpdateOfPrefersPointerLocked()

        setNeedsModalPresentationStatusBarAppearanceUpdate()
        setNeedsModalPresentationStyleUpdate()
    }
}
