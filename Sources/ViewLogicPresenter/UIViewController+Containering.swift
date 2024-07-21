//
//  UIViewController+Containering.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - Child View Controllers

extension UIViewController {

    /**
     This is a helper method that calls the install method non-forcibly. Use it before the receiver's root view has been loaded, or when it's not known whether it's loaded or not.

     - Parameter child: A view controller to be installed into the receiver as a child.

     - Parameter view: Pass in `nil` to install into the receiver's root view, otherwise pass in a subview of the receiver's root view. This value is ignored if the receiver's root view is not yet loaded. The default value is `nil`.

     - Parameter toEdges: Pass in `true` in order to pin the child view controller to the edges of the parent view or view controller, or `false` in order to pin it to the corresponding safe area. This value is ignored if the receiver's root view is not yet loaded. The default value is `true`.

     - Returns: the child controller's pinning result, if the view controller gets pinned to its parent as part of the call, `nil` otherwise.
     */
    @discardableResult
    func installNonForcibly(childViewController child: UIViewController, intoView view: UIView? = nil, toEdges: Bool = true) -> ViewPinResult? {

        install(childViewController: child, intoView: view, toEdges: toEdges, forceLoadView: false)
    }

    /**
     This is a helper method that calls the install method non-forcibly. Use it after the receiver's root view has been loaded.

     - Returns: the child controller's pinning result, if the view controller gets pinned to its parent as part of the call, `nil` otherwise.
     */
    @discardableResult
    func finishInstall(childViewController child: UIViewController, intoView view: UIView? = nil, toEdges: Bool = true) -> ViewPinResult? {

        install(childViewController: child, intoView: view, toEdges: toEdges, forceLoadView: false)
    }

    /**
     Installs the specified view controller as a child one into the receiver

     This method can either install the child view controller fully, which means its root view is added into the receiver's view, and the ``didMove(toParent:)`` method of the view controller is called, or partially, which means that only the ``addChild()`` method of the receiver is called. This depends on whether or not the receiver's root view is loaded at the moment this method is called. The full installation can also be forced regardless of the receiver's root view load status, by passing `true` into the ``forceLoadView`` parameter. This will mean that in case the view isn't loaded yet, it will be loaded synchronously.

     - Parameter child: A view controller to be installed into the receiver as a child.

     - Parameter view: Pass in `nil` to install into the receiver's root view, otherwise pass in a subview of the receiver's root view. This value is ignored if `forceLoadView` is `false` and the receiver's root view is not yet loaded. The default value is `nil`.
     
     - Parameter toEdges: Pass in `true` in order to pin the child view controller to the edges of the parent view or view controller, or `false` in order to pin it to the corresponding safe area. This value is ignored if `forceLoadView` is `false` and the receiver's root view is not yet loaded. The default value is `true`.

     - Parameter forceLoadView: Pass in `true` in order to force the receiver's root view to load synchronously if it is not loaded at the moment of the call, `false` otherwise. In the case of passing `false` the caller must make sure it calls this method after the view is loaded, ie after the receiver's ``viewDidLoad(animated:)`` is called. The default value is `true`.

     - Returns: the child controller's pinning result, if the view controller gets pinned to its parent as part of the call, `nil` otherwise.
     */
    @discardableResult
    func install(childViewController child: UIViewController, intoView view: UIView? = nil, toEdges: Bool = true, forceLoadView: Bool = true) -> ViewPinResult? {

        if !children.contains(child) {
            addChild(child)
        }

        guard forceLoadView || isViewLoaded else {
            return nil // not fully installed - 'install' must be called one more time later when the receiver's 'viewDidLoad' fires
        }

        var result: ViewPinResult?
        let parentView: UIView = view ?? self.view
        if !parentView.subviews.contains(child.view) {

            parentView.addSubview(child.view)
            child.view.translatesAutoresizingMaskIntoConstraints = false
            result = child.view.pinTo(view: parentView, options: toEdges ? .edges : .safeArea, insets: .zero, priorities: .required, deferActivation: false)
        }

        child.didMove(toParent: self)
        return result
    }

    /**
     Uninstalls the receiver from its parent view controller
     */
    @objc
    func uninstallFromParentViewController() {

        willMove(toParent: nil)
        if isViewLoaded {
            view.removeFromSuperview()
        }
        removeFromParent()
    }
}

// MARK: - Obj Wrapper

@objc
extension UIViewController {

    /**
     This is Objective-C wrapper for a helper method that calls the install method non-forcibly. Use it before the receiver's root view has been loaded, or when it's not known whether it's loaded or not.

     - Parameter child: A view controller to be installed into the receiver as a child.

     - Parameter view: Pass in `nil` to install into the receiver's root view, otherwise pass in a subview of the receiver's root view. This value is ignored if the receiver's root view is not yet loaded. The default value is `nil`.

     - Parameter toEdges: Pass in `true` in order to pin the child view controller to the edges of the parent view or view controller, or `false` in order to pin it to the corresponding safe area. This value is ignored if the receiver's root view is not yet loaded. The default value is `true`.
     */
    func installChildViewControllerNonForcibly(_ child: UIViewController, intoView view: UIView? = nil, toEdges: Bool = true) {

        installNonForcibly(childViewController: child, intoView: view, toEdges: toEdges)
    }

    /**
     This is Objective-C wrapper for a helper method that calls the install method non-forcibly. Use it after the receiver's root view has been loaded.
     */
    func finishInstallChildViewController(_ child: UIViewController, intoView view: UIView? = nil, toEdges: Bool = true) {
        finishInstall(childViewController: child, intoView: view, toEdges: toEdges)
    }

    /**
     This is Objective-C wrapper for a helper method that installs the specified view controller as a child one into the receiver.

     This method can either install the child view controller fully, which means its root view is added into the receiver's view, and the ``didMove(toParent:)`` method of the view controller is called, or partially, which means that only the ``addChild()`` method of the receiver is called. This depends on whether or not the receiver's root view is loaded at the moment this method is called. The full installation can also be forced regardless of the receiver's root view load status, by passing `true` into the ``forceLoadView`` parameter. This will mean that in case the view isn't loaded yet, it will be loaded synchronously.

     - Parameter child: A view controller to be installed into the receiver as a child.

     - Parameter view: Pass in `nil` to install into the receiver's root view, otherwise pass in a subview of the receiver's root view. This value is ignored if `forceLoadView` is `false` and the receiver's root view is not yet loaded. The default value is `nil`.

     - Parameter toEdges: Pass in `true` in order to pin the child view controller to the edges of the parent view or view controller, or `false` in order to pin it to the corresponding safe area. This value is ignored if `forceLoadView` is `false` and the receiver's root view is not yet loaded. The default value is `true`.

     - Parameter forceLoadView: Pass in `true` in order to force the receiver's root view to load synchronously if it is not loaded at the moment of the call, `false` otherwise. In the case of passing `false` the caller must make sure it calls this method after the view is loaded, ie after the receiver's ``viewDidLoad(animated:)`` is called. The default value is `true`.
     */
    func installChildViewController(_ child: UIViewController, intoView view: UIView? = nil, toEdges: Bool = true, forceLoadView: Bool = true) {
        install(childViewController: child, intoView: view, toEdges: toEdges, forceLoadView: forceLoadView)
    }
}
