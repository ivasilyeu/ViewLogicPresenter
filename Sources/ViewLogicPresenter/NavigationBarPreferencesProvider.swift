//
//  NavigationBarPreferencesProvider.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - NavigationBarPreferencesProvider

/**
 Adopt this protocol on a view controller that needs to control the navigation bar properties when is being shown by an instance of UINavigationController
 */
protocol NavigationBarPreferencesProvider: UIViewController {

    /**
     Implement to return a preferences value for the navigation bar of the navigation controller which the receiver is pushed into. This value will be used if ``childForNavigationBarPreferences`` returns `nil`.
     Whenever the value of this property changes, ``setNeedsNavigationBarPreferencesUpdate()`` should be called.
     */
    var navigationBarPreferences: NavigationBarPreferences { get }

    /**
     Implement to return a child view controller or nil. If non-nil, that view controller's navigation bar preference attributes will be used. If nil, self is used. Whenever the return value from this method changes, ``setNeedsNavigationBarPreferencesUpdate()`` should be called.
     */
    var childForNavigationBarPreferences: NavigationBarPreferencesProvider? { get }
}

// MARK: - Update

extension NavigationBarPreferencesProvider {

    /**
     Call this method to update the navigation bar according to the current preferences
     */
    func setNeedsNavigationBarPreferencesUpdate() {

        guard let navigation = retrieveNavigationController() else {
            return
        }

        let preferences = retrieveNavigationBarPreferences()
        navigation.navigationBar.applyPreferences(preferences)
        navigation.setNavigationBarHidden(preferences.isHidden, animated: false)
    }

    // MARK: Implementation

    private func retrieveNavigationController() -> UINavigationController? {

        if let navigation = parent as? UINavigationController {
            return navigation
        }

        guard let parentProvider = parent as? NavigationBarPreferencesProvider else {
            return nil
        }

        return parentProvider.childForNavigationBarPreferences === self ? parentProvider.retrieveNavigationController() : nil
    }

    private func retrieveNavigationBarPreferences() -> NavigationBarPreferences {

        let preferences: NavigationBarPreferences
        if let child = childForNavigationBarPreferences {
            preferences = child.retrieveNavigationBarPreferences()
        } else {
            preferences = navigationBarPreferences
        }
        return preferences
    }
}

// MARK: - Default

extension NavigationBarPreferencesProvider {

    var navigationBarPreferences: NavigationBarPreferences { Self.defaultNavigationBarPreferences }

    /**
     */
    static var defaultNavigationBarPreferences: NavigationBarPreferences {
        NavigationBarPreferences(isHidden: false)
    }

    var childForNavigationBarPreferences: NavigationBarPreferencesProvider? { nil }
}
