//
//  MultitabBarController.swift
//  IV
//
//  Created by IV on 11.01.2023.
//  Copyright © 2023 IV. All rights reserved.
//

import UIKit

// MARK: - MultitabBarControllerDelegate

protocol MultitabBarControllerDelegate: AnyObject {

    /**
     */
    func multitabBarController(_ controller: MultitabBarController, controllerForTab tab: TabDescriptor) -> UIViewController

    /**
     User selected a tab by tapping on it.

     - Note: is not called when a tab selected programmatically.
     */
    func multitabBarController(_ controller: MultitabBarController, didSelectTab tab: TabDescriptor, oldSelectedTab: TabDescriptor?)
}

// MARK: - MultitabBarController

/**
 ``MultitabBarController`` is a container view controller that behaves like ``UITabBarController``, but allows to share child view controllers between multiple tabs.
 */
@objc
final class MultitabBarController: UIViewController {

    // MARK: Initialization

    init(tabs: [TabDescriptor]) {

        self.tabs = tabs
        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let tabs: [TabDescriptor]

    private func setup() {
        installNonForcibly(childViewController: contentHostController, belowView: tabBar)
    }

    private lazy var contentHostController = MultitabHostController()

    // MARK:

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        let result = tabBar.pinToSuperview(options: .safeArea)
        result.top.isActive = false
        tabBarBottomConstraint = result.bottom

        tabBar.delegate = self
        tabBar.items = tabs.map(createTabBarItem)

        updateView()

        finishInstall(childViewController: contentHostController, belowView: tabBar)
    }

    private func createTabBarItem(for tab: TabDescriptor) -> UITabBarItem {
        UITabBarItem(title: tab.title, image: tab.image, selectedImage: tab.selectedImage)
    }

    private func updateView() {
        guard isViewLoaded else { return}

        updateTabBarSelection()
        updateTabBarVisibility()
    }

    private func updateTabBarSelection() {
        guard isViewLoaded else { return}
        tabBar.selectedItem = selectedTabIndex.flatMap { tabBar.items?[$0] }
    }

    private func updateTabBarVisibility() {
        guard isViewLoaded else { return}

        let isHidden = tabBarHidden
        tabBarBottomConstraint?.constant = isHidden ? hiddenTabBarBottomOffset : 0
        tabBar.alpha = isHidden ? 0 : 1
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateAdditionalSafeAreaInsetsIfNeeded()
    }

    private func updateAdditionalSafeAreaInsetsIfNeeded() {
        precondition(isViewLoaded, "root view isn't loaded")

        let barFrame = tabBarHidden ? .zero : view.convert(tabBar.frame, to: contentHostController.view)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: barFrame.height, right: 0)
        
        if contentHostController.additionalSafeAreaInsets != insets {
            contentHostController.additionalSafeAreaInsets = insets
        }
    }

    private(set) lazy var tabBar = UITabBar()
    private var tabBarBottomConstraint: NSLayoutConstraint?

    // MARK:

    weak var delegate: MultitabBarControllerDelegate?

    var tabBarHidden: Bool = false {
        didSet {
            updateTabBarVisibility()
        }
    }

    func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        guard isViewLoaded && animated else {
            tabBarHidden = isHidden
            return
        }

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.tabBarHidden = isHidden
            self.view.layoutIfNeeded()
        }
    }

    private let hiddenTabBarBottomOffset: CGFloat = 100 // an arbitrary value - it just needs to be greater than the bottom safe area inset

    var selectedTab: TabDescriptor? {
        selectedTabIndex.map { tabs[$0] }
    }

    func selectTab(_ tab: TabDescriptor) {
        guard let tabIndex = tabs.firstIndex(of: tab) else {
            return
        }

        if tabIndex != selectedTabIndex {
            selectedTabIndex = tabIndex
            updateTabBarSelection()

            showTabController(for: tab)
        }
    }

    private var selectedTabIndex: Int?

    fileprivate func showTabController(for tab: TabDescriptor) {

        let controller = delegate?.multitabBarController(self, controllerForTab: tab)
        
        guard controller !== shownTabController else {
            return
        }

        shownTabController = controller
        contentHostController.hostedContent = controller
    }

    /**
     View controller of the currently selected tab.

     - Note: some tabs may share the same view controller instance.
     */
    private(set) var shownTabController: UIViewController?

    /**
     */
    func setBadge(value: Int, forTab tab: TabDescriptor) {
        guard let tabIndex = tabs.firstIndex(of: tab) else {
            return
        }

        guard let item = tabBar.items?[tabIndex] else {
            return
        }

        let stringValue = value > 0 ? NumberFormatter.localizedString(from: NSNumber(value: value), number: .none) : nil
        item.badgeValue = stringValue
    }
}

// MARK: - UITabBarDelegate

extension MultitabBarController: UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let tabIndex = tabBar.items?.firstIndex(of: item) else { return }

        let oldTab = selectedTabIndex.map { tabs[$0] }
        let tab = tabs[tabIndex]

        if tabIndex != selectedTabIndex {
            selectedTabIndex = tabIndex
            showTabController(for: tab)
        }

        delegate?.multitabBarController(self, didSelectTab: tab, oldSelectedTab: oldTab)
    }
}

// MARK: - External Preferences

extension MultitabBarController {

    override var childForStatusBarStyle: UIViewController? {
        contentHostController
    }

    override var childForStatusBarHidden: UIViewController? {
        contentHostController
    }

    override var childForHomeIndicatorAutoHidden: UIViewController? {
        contentHostController
    }

    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        contentHostController
    }

    override var childViewControllerForPointerLock: UIViewController? {
        contentHostController
    }

    fileprivate func setNeedsUpdateExternalPreferences() {

        setNeedsStatusBarAppearanceUpdate()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        setNeedsUpdateOfPrefersPointerLocked()
    }
}
