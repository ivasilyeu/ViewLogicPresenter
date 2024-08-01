//
//  MessageViewController.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - MessageViewController

open class MessageViewController: UIViewController, NavigationBarPreferencesProvider {

    convenience init() {
        self.init(title: "", message: "", showSpinner: false)
    }

    @objc
    init(title: String, message: String, showSpinner: Bool) {
        super.init(nibName: nil, bundle: nil)

        self.title = title

        label.text = message
        spinner.hidesWhenStopped = false
        spinner.isHidden = !showSpinner
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var navigationBarPreferences: NavigationBarPreferences = MessageViewController.defaultNavigationBarPreferences

    open override var prefersStatusBarHidden: Bool {
        get {
            storedPrefersStatusBarHidden
        }
        set {
            storedPrefersStatusBarHidden = newValue
        }
    }

    private var storedPrefersStatusBarHidden = false

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            storedPreferredStatusBarStyle
        }
        set {
            storedPreferredStatusBarStyle = newValue
        }
    }

    private var storedPreferredStatusBarStyle: UIStatusBarStyle = .default

    @objc
    var message: String {
        get { label.text ?? "" }
        set { label.text = newValue }
    }

    @objc
    var showsSpinner: Bool {
        get { !spinner.isHidden }
        set { spinner.isHidden = !newValue }
    }

    private lazy var spinner: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        return indicator
    }()

    @objc
    private(set) lazy var label: UILabel = {
        let l = UILabel()

        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byTruncatingTail
        l.allowsDefaultTighteningForTruncation = true
        l.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        l.textColor = .secondaryLabel
        return l
    }()

    private lazy var stackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [spinner, label])
        v.axis = .vertical
        v.spacing = 2
        return v
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !spinner.isHidden { spinner.startAnimating() }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if !spinner.isHidden { spinner.stopAnimating() }
    }
}

// MARK: - Update Properties Preferences

extension MessageViewController {

    func updatePropertiesAndPreferences(with srcController: UIViewController,
                                        updateNavigationItem: Bool = true,
                                        updateExtendedLayoutIncludesOpaqueBars: Bool = true,
                                        updateHidesBottomBarWhenOnTopOfNavigationStack: Bool = true,
                                        updateModalPresentationCapturesStatusBarAppearance: Bool = true,
                                        updateModalPresentationStyle: Bool = true,
                                        updatePreferredStatusBarStyle: Bool = true,
                                        updatePrefersStatusBarHidden: Bool = true,
                                        updateNavigationBarPreferences: Bool = true) {

        if updateNavigationItem {
            /*
             Navigation bar button items must not be blindly relinked (semantically incorrect) because the source's navigation item buttons have their custom actions and handlers set by / to the source navigation item's view controller
             */
            navigationItem.update(with: srcController.navigationItem, applyHandlers: false)
        }

        if updateExtendedLayoutIncludesOpaqueBars {
            extendedLayoutIncludesOpaqueBars = srcController.extendedLayoutIncludesOpaqueBars
        }

        if updateHidesBottomBarWhenOnTopOfNavigationStack {
            hidesBottomBarWhenOnTopOfNavigationStack = srcController.hidesBottomBarWhenOnTopOfNavigationStack
        }

        if updateModalPresentationCapturesStatusBarAppearance {
            modalPresentationCapturesStatusBarAppearance = srcController.modalPresentationCapturesStatusBarAppearance
        }

        if updateModalPresentationStyle {
            modalPresentationStyle = srcController.modalPresentationStyle
        }

        if updatePreferredStatusBarStyle {
            preferredStatusBarStyle = srcController.preferredStatusBarStyle
        }

        if updatePrefersStatusBarHidden {
            prefersStatusBarHidden = srcController.prefersStatusBarHidden
        }

        if updateNavigationBarPreferences, let preferencesProvider = srcController as? NavigationBarPreferencesProvider {
            navigationBarPreferences = preferencesProvider.navigationBarPreferences
        }
    }
}
