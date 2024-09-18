//
//  NavigationController.swift
//  IV
//
//  Created by IV on 19.02.2021.
//

import UIKit

// MARK: - NavigationBarPreferencesDelegate

/**
 Conforming types must implement updates to the navigation bar preferences when the navigation stack changes, by calling ``setNeedsNavigationBarPreferencesUpdate(for viewController:)``. Typically this means implementing the ``navigationController(_ navigationController:, willShow viewController:, animated:)`` optional method of UINavigationControllerDelegate.
 */
protocol NavigationBarPreferencesDelegate: UINavigationControllerDelegate {
}

// MARK: - Helpers

extension NavigationBarPreferencesDelegate {

    func setNeedsNavigationBarPreferencesUpdate(for viewController: UIViewController) {
        guard let provider = viewController as? NavigationBarPreferencesProvider else { return }
        provider.setNeedsNavigationBarPreferencesUpdate()
    }
}
