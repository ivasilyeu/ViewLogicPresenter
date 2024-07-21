//
//  LoadableModel.swift
//
//  Created by IV on 01.12.2016.
//

// MARK: - LoadableModel

/**
 A generic loadable model
 */
struct LoadableModel<ContentType, ErrorType: Error>: LoadableModelProtocol {

    var statefulContent: StatefulContent<ContentType> = .empty

    var isLoadingContent = false

    var lastError: ErrorType?
}
