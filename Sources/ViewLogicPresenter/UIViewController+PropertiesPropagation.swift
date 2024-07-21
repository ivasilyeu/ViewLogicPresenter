//
//  UIViewController+PropertiesPropagation.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - NavigationItem

@objc
extension UIViewController {

    /**
     Corresponds to `UIViewController.navigationItem`

     Default implementation returns `nil`
     */
    var childForNavigationItem: UIViewController? { nil }

    /**
     */
    func setNeedsNavigationItemUpdate() {

        let source = retrieveNavigationItemSource()
        let destination = retrieveNavigationItemDestination()
        guard destination !== source else { return }

        let sourceItem = source.navigationItem
        guard destination.navigationItem !== sourceItem else { return }

        destination.navigationItem.update(with: sourceItem, applyHandlers: true)
    }
}

fileprivate extension UIViewController {

    func retrieveNavigationItemSource() -> UIViewController {
        childForNavigationItem?.retrieveNavigationItemSource() ?? self
    }

    func retrieveNavigationItemDestination() -> UIViewController {
        guard let parent else { return self }
        return parent.childForNavigationItem === self ? parent.retrieveNavigationItemDestination() : self
    }
}

// MARK: - ExtendedLayout

@objc
extension UIViewController {

    /**
     Corresponds to `UIViewController.extendedLayoutIncludesOpaqueBars`
     */
    var childForExtendedLayoutIncludingOpaqueBars: UIViewController? { nil }

    /**
     */
    func setNeedsExtendedLayoutIncludingOpaqueBarsUpdate() {
        let source = retrieveExtendedLayoutIncludingOpaqueBarsSource()
        let destination = retrieveExtendedLayoutIncludingOpaqueBarsDestination()
        guard destination.extendedLayoutIncludesOpaqueBars != source.extendedLayoutIncludesOpaqueBars else {
            return
        }

        destination.extendedLayoutIncludesOpaqueBars = source.extendedLayoutIncludesOpaqueBars
    }
}

fileprivate extension UIViewController {

    func retrieveExtendedLayoutIncludingOpaqueBarsSource() -> UIViewController {
        childForExtendedLayoutIncludingOpaqueBars?.retrieveExtendedLayoutIncludingOpaqueBarsSource() ?? self
    }

    func retrieveExtendedLayoutIncludingOpaqueBarsDestination() -> UIViewController {
        guard let parent else { return self }
        return parent.childForExtendedLayoutIncludingOpaqueBars === self ? parent.retrieveExtendedLayoutIncludingOpaqueBarsDestination() : self
    }
}

// MARK: - BottomBar

@objc
extension UIViewController {

    /**
     Corresponds to `UIViewController.hidesBottomBarWhenPushed`.
     */
    var hidesBottomBarWhenOnTopOfNavigationStack: Bool {
        get {
            hidesBottomBarWhenPushed
        }
        set {
            hidesBottomBarWhenPushed = newValue
            updateTabBarVisibilityIfAlreadyOnTopOfNavigationStack()
        }
    }

    /**
     Corresponds to `UIViewController.hidesBottomBarWhenPushed`.
     */
    var childForHidingBottomBarWhenOnTopOfNavigationStack: UIViewController? { nil }

    /**
     */
    func setNeedsHidingBottomBarWhenOnTopOfNavigationStackUpdate() {
        let source = retrieveHidingBottomBarWhenOnTopOfNavigationStackSource()
        let destination = retrieveHidingBottomBarWhenOnTopOfNavigationStackDestination()
        guard destination.hidesBottomBarWhenOnTopOfNavigationStack != source.hidesBottomBarWhenOnTopOfNavigationStack else {
            return
        }

        destination.hidesBottomBarWhenOnTopOfNavigationStack = source.hidesBottomBarWhenOnTopOfNavigationStack
    }
}

fileprivate extension UIViewController {

    func retrieveHidingBottomBarWhenOnTopOfNavigationStackSource() -> UIViewController {
        childForHidingBottomBarWhenOnTopOfNavigationStack?.retrieveHidingBottomBarWhenOnTopOfNavigationStackSource() ?? self
    }

    func retrieveHidingBottomBarWhenOnTopOfNavigationStackDestination() -> UIViewController {
        guard let parent else { return self }
        return parent.childForHidingBottomBarWhenOnTopOfNavigationStack === self ? parent.retrieveHidingBottomBarWhenOnTopOfNavigationStackDestination() : self
    }

    func updateTabBarVisibilityIfAlreadyOnTopOfNavigationStack() {

        /*
         Dynamically shows or hides the bottom bar if needed, in the case the view controller has already been pushed prior to its `hidesBottomBarWhenPushed` property change.
         This is needed because otherwise a view controller that is already been shown inside a navigation stack and that is then dynamically changes its `hidesBottomBarWhenPushed` property will never cause the tab bar to show or hide, a "repush" is needed for the property to be taken into account by UIKit.
         */
        guard let navigation = navigationController, navigation.topViewController === self else {
            return
        }

        guard let tabBarController = tabBarController, tabBarController.tabBar.isHidden != hidesBottomBarWhenPushed else {
            return
        }

        navigation.popViewController(animated: false)
        navigation.pushViewController(self, animated: false)
    }
}

// MARK: - StatusBar

@objc
extension UIViewController {

    /**
     Corresponds to `UIViewController.modalPresentationCapturesStatusBarAppearance`.
     */
    var childForModalPresentationStatusBarAppearance: UIViewController? { nil }

    /**
     */
    func setNeedsModalPresentationStatusBarAppearanceUpdate() {
        let source = retrieveModalPresentationStatusBarAppearanceSource()
        let destination = retrieveModalPresentationStatusBarAppearanceDestination()
        guard destination.modalPresentationCapturesStatusBarAppearance != source.modalPresentationCapturesStatusBarAppearance else {
            return
        }

        destination.modalPresentationCapturesStatusBarAppearance = source.modalPresentationCapturesStatusBarAppearance
    }
}

fileprivate extension UIViewController {

    func retrieveModalPresentationStatusBarAppearanceSource() -> UIViewController {
        childForModalPresentationStatusBarAppearance?.retrieveModalPresentationStatusBarAppearanceSource() ?? self
    }

    func retrieveModalPresentationStatusBarAppearanceDestination() -> UIViewController {
        guard let parent else { return self }
        return parent.childForModalPresentationStatusBarAppearance === self ? parent.retrieveModalPresentationStatusBarAppearanceDestination() : self
    }
}

// MARK: - ModalPresentationStyle

@objc
extension UIViewController {

    /**
     Corresponds to `UIViewController.modalPresentationStyle`.
     */
    var childForModalPresentationStyle: UIViewController? { nil }

    /**
     */
    func setNeedsModalPresentationStyleUpdate() {
        let source = retrieveModalPresentationStyleSource()
        let destination = retrieveModalPresentationStyleDestination()
        guard destination.modalPresentationStyle != source.modalPresentationStyle else {
            return
        }

        destination.modalPresentationStyle = source.modalPresentationStyle
    }
}

fileprivate extension UIViewController {

    func retrieveModalPresentationStyleSource() -> UIViewController {
        childForModalPresentationStyle?.retrieveModalPresentationStyleSource() ?? self
    }

    func retrieveModalPresentationStyleDestination() -> UIViewController {
        guard let parent else { return self }
        return parent.childForModalPresentationStyle === self ? parent.retrieveModalPresentationStyleDestination() : self
    }
}
