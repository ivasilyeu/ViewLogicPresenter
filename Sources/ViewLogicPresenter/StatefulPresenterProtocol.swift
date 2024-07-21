//
//  StatefulPresenterProtocol.swift
//
//  Created by IV on 01.12.2016.
//

import Foundation
import class UIKit.UIViewController

// MARK: - StatefulPresenterProtocol

/**
 ``StatefulPresenterProtocol`` conforming presenters operate on ``StateViewController`` as their root view controller.
 There're 4 states possible: content, empty, loading and error
 */
protocol StatefulPresenterProtocol: PresenterProtocol where RootViewControllerType == StateViewController {

    associatedtype ErrorType: Error = Error

    associatedtype EmptyViewControllerType: UIViewController = MessageViewController
    associatedtype LoadingViewControllerType: UIViewController = MessageViewController
    associatedtype ContentViewControllerType: UIViewController
    associatedtype ErrorViewControllerType: UIViewController = MessageViewController

    /**
     Implementation should derive a state based on the model provided.
     A default implementation is available
     */
    func evaluateCurrentState(with model: LoadableModel<ModelType, ErrorType>) -> StateViewController.State

    /**
     The Presenter's content view controller
     - Note: It is preferred to be backed by a stored property and reused
     */
    func contentViewController(_ model: ModelType) -> ContentViewControllerType

    /**
     A default implementation is available
     - Note: It is preferred to be backed by a stored property and reused
     */
    func emptyViewController() -> EmptyViewControllerType

    /**
     A default implementation is available
     - Note: It is preferred to be backed by a stored property and reused
     */
    func loadingViewController() -> LoadingViewControllerType

    /**
     A default implementation is available
     - Note: It is preferred to be backed by a stored property and reused
     */
    func errorViewController(_ error: ErrorType) -> ErrorViewControllerType
}

/**
 Default implementations
 */
extension StatefulPresenterProtocol {

    /**
     State evaluation based on the model provided.
     Provide a custom implementation if there's need to change the default logic of switching between content, error and loading states UI
     */
    func evaluateCurrentState(with model: LoadableModel<ModelType, ErrorType>) -> StateViewController.State {

        let state: StateViewController.State

        if case let .some(content) = model.statefulContent {
            state = .content(controller: contentViewController(content))
        } else if model.isLoadingContent {
            state = .loading(controller: loadingViewController())
        } else if let error = model.lastError {
            state = .error(controller: errorViewController(error))
        } else /* case .empty = model.statefulContent */ {
            state = .empty(controller: emptyViewController())
        }

        return state
    }

    /**
     The following default implementations are useful for Presenters where there's no empty state
     */
    func emptyViewController() -> EmptyViewControllerType {

        let controller = EmptyViewControllerType()

        if let messageController = controller as? MessageViewController {
            messageController.message = NSLocalizedString("NO_DATA", comment: "")
            messageController.showsSpinner = false
        }

        return controller
    }

    /**
     The following default implementations are useful for Presenters where there's no loading state
     */
    func loadingViewController() -> LoadingViewControllerType {

        let controller = LoadingViewControllerType()

        if let messageController = controller as? MessageViewController {
            messageController.message = NSLocalizedString("LOADING", comment: "")
            messageController.showsSpinner = true
        }

        return controller
    }

    /**
     The following default implementations are useful for Presenters where there's no error state
     */
    func errorViewController(_ error: ErrorType) -> ErrorViewControllerType {

        let controller = ErrorViewControllerType()

        if let messageController = controller as? MessageViewController {
            messageController.message = NSLocalizedString("CONNECTION_ERROR_MESSAGE_V2", comment: "")
            messageController.showsSpinner = false
        }

        return controller
    }
}

// MARK: - Helpers

extension StatefulPresenterProtocol {

    var currentState: StateViewController.State {
        rootViewController.state
    }

    func updateState(withModel model: LoadableModel<ModelType, ErrorType>) {
        rootViewController.state = evaluateCurrentState(with: model)
    }
}
