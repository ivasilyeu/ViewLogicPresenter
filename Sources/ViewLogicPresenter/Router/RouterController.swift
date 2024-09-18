//
//  RouterController.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - RouterController

/**
 Abstract base class. Derive all Router controllers from it.

 - Note: ``RouterController`` corresponds to Router from VIPER architectural design pattern.
 */
open class RouterController: UIViewController {

    fileprivate(set) weak var currentExternalPreferencesChild: UIViewController?
}

// MARK: - ExternalPreferencesUpdate

extension RouterController {

    /**
     Apply a child view controller which should control the external preferences

     The external preferences are the following:
     - status bar appearance
     - home indicator
     - screen edges gestures
     - pointer locking
     - navigation item
     - navigation bar appearance
     - extended layout preferences
     - bottom bar state
     - other external preferences
     */
    func applyChildForExternalPreferences(_ child: UIViewController?) {

        if let child {
            assert(children.contains(child), "the specified view controller is not part of the children array")
        }

        currentExternalPreferencesChild = child
        setNeedsUpdateExternalPreferences()
    }

    open override var childForStatusBarStyle: UIViewController? {
        currentExternalPreferencesChild
    }

    open override var childForStatusBarHidden: UIViewController? {
        currentExternalPreferencesChild
    }

    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        currentExternalPreferencesChild
    }

    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        currentExternalPreferencesChild
    }

    open override var childViewControllerForPointerLock: UIViewController? {
        currentExternalPreferencesChild
    }

    override var childForNavigationItem: UIViewController? {
        currentExternalPreferencesChild
    }

    override var childForExtendedLayoutIncludingOpaqueBars: UIViewController? {
        currentExternalPreferencesChild
    }

    override var childForModalPresentationStatusBarAppearance: UIViewController? {
        currentExternalPreferencesChild
    }

    override var childForHidingBottomBarWhenOnTopOfNavigationStack: UIViewController? {
        currentExternalPreferencesChild
    }

    override var childForModalPresentationStyle: UIViewController? {
        currentExternalPreferencesChild
    }

    private func setNeedsUpdateExternalPreferences() {

        setNeedsStatusBarAppearanceUpdate()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        if #available(iOS 14.0, *) {
        setNeedsUpdateOfPrefersPointerLocked()
        }

        setNeedsNavigationItemUpdate()
        setNeedsExtendedLayoutIncludingOpaqueBarsUpdate()
        setNeedsHidingBottomBarWhenOnTopOfNavigationStackUpdate()
        setNeedsModalPresentationStatusBarAppearanceUpdate()
        setNeedsNavigationBarPreferencesUpdate()
        setNeedsModalPresentationStyleUpdate()
    }
}

// MARK: - NavigationBarPreferencesProvider

extension RouterController: NavigationBarPreferencesProvider {

    var childForNavigationBarPreferences: NavigationBarPreferencesProvider? {
        currentExternalPreferencesChild as? NavigationBarPreferencesProvider
    }
}
