//
//  StateViewController.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - StateViewController

final class StateViewController: UIViewController {

    enum State {
        case loading(controller: UIViewController)
        case content(controller: UIViewController)
        case error(controller: UIViewController)
        case empty(controller: UIViewController)
    }

    var state: State = .empty(controller: MessageViewController(title: "", message: NSLocalizedString("NO_DATA", comment: ""), showSpinner: false)) {
        didSet {
            applyState()
        }
    }

    private func applyState() {
        contentController = viewController(for: state)
    }
    
    private func viewController(for state: State) -> UIViewController {
        switch state {
        case let .loading(controller), let .empty(controller), let .error(controller), let .content(controller):
            return controller
        }
    }

    private var contentController: UIViewController? {
        didSet {
            guard contentController != oldValue else { return }

            swapContent(newValue: contentController, oldValue: oldValue)

            setNeedsUpdateExternalPreferences()
        }
    }

    private func swapContent(newValue: UIViewController?, oldValue: UIViewController?) {

        oldValue?.uninstallFromParentViewController()
        guard let controller = newValue else { return }

        install(childViewController: controller)
    }

    override func loadView() {
        view = UIView()
        applyState()
    }
}

// MARK: - ExternalPreferencesUpdate

extension StateViewController {
    
    override var childForStatusBarStyle: UIViewController? {
        contentController
    }

    override var childForStatusBarHidden: UIViewController? {
        contentController
    }

    override var childForHomeIndicatorAutoHidden: UIViewController? {
        contentController
    }

    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        contentController
    }

    override var childViewControllerForPointerLock: UIViewController? {
        contentController
    }

    override var childForNavigationItem: UIViewController? {
        contentController
    }

    override var childForExtendedLayoutIncludingOpaqueBars: UIViewController? {
        contentController
    }

    override var childForModalPresentationStatusBarAppearance: UIViewController? {
        contentController
    }

    override var childForHidingBottomBarWhenOnTopOfNavigationStack: UIViewController? {
        contentController
    }

    override var childForModalPresentationStyle: UIViewController? {
        contentController
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

extension StateViewController: NavigationBarPreferencesProvider {

    var childForNavigationBarPreferences: NavigationBarPreferencesProvider? {
        contentController as? NavigationBarPreferencesProvider
    }
}
