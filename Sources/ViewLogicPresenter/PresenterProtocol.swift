//
//  PresenterProtocol.swift
//
//  Created by IV on 01.12.2016.
//

import class UIKit.UIViewController

// MARK: - PresenterProtocol

/**
 ``PresenterProtocol`` represents a semantically related set of view controllers, a domain model and optionally a logic controller, that are presented to the user as a single coherent piece of UI. A presenter might or might not occupy the entire screen.
 Any presenter does:
 - define its model type
 - create and hold view controllers by performing the model conversion into view model and back.
 */
protocol PresenterProtocol: AnyObject, Identifiable {

    /**
     Model is the primary piece of data for a Presenter, which can be set from outside the Presenter and influences the Presenter's visualization and / or behaviour
     */
    associatedtype ModelType

    /**
     Root view controller is responsible for the Presenter's visualization.

     - Note: View controllers MUST NOT contain or make any business logic assumptions or calculations of any sort other than strictly visualization related. Neither they should interpret user actions on any level except strictly UI related (eg, `viewControllerDidTapButton(:)` is a correct example of such interpretation, while `viewControllerDidRequestUserProfile(:)` is NOT a correct one).
     */
    associatedtype RootViewControllerType: UIViewController

    /**
     The Presenter's root view controller.
     - Note: This MUST be a stored property
     */
    var rootViewController: RootViewControllerType { get }
}
