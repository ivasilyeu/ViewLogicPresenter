//
//  NavigationBarPreferences.swift
//
//  Created by IV on 01.12.2016.
//

import class UIKit.UINavigationBar
import class UIKit.UIColor

// MARK: - NavigationBarPreferences

/**
 - Note: Only extend this type with general-type UINavigationBar properties, ie those that cannot be modified with UINavigationBarAppearance
 */
struct NavigationBarPreferences {

    /**
     The default value is `false`
     */
    var isHidden: Bool = false

    /**
     The default value is `true`
     */
    var prefersLargeTitles: Bool = true

    /**
     The tint color is supported via NavigationBarPreferences because it is still apparently the only way to change the back button chevron color - trying to use the barAppearance APIs doesn't work for that purpose for some reason, at least up to iOS 15.5.

     The default value is `nil`, which means no tint color change is applied by applying of the preferences
     */
    var tintColor: UIColor?
}

// MARK: - Helpers

extension NavigationBarPreferences {

    static let navigationBarHidden: Self = .init(isHidden: true)

    static let navigationBarShown: Self = .init(isHidden: false)

    // other predefined preferences may be added here...
}

// MARK: - UINavigationBar+Preferences

extension UINavigationBar {

    func applyPreferences(_ preferences: NavigationBarPreferences) {
        isHidden = preferences.isHidden
        prefersLargeTitles = preferences.prefersLargeTitles
        if let color = preferences.tintColor {
            tintColor = color
        }
    }
}
