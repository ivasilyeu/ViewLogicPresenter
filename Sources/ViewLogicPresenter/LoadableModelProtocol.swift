//
//  LoadableModelProtocol.swift
//
//  Created by IV on 01.12.2016.
//

// MARK: - LoadableModelProtocol

protocol LoadableModelProtocol {

    associatedtype ContentType
    associatedtype ErrorType: Error

    var statefulContent: StatefulContent<ContentType> { get set }

    var isLoadingContent: Bool { get set }

    var lastError: ErrorType? { get set }

    init()
}

// MARK: - Initialization

extension LoadableModelProtocol {

    init(statefulContent: StatefulContent<ContentType>, isLoadingContent: Bool, lastError: ErrorType?) {
        self.init()

        self.statefulContent = statefulContent
        self.isLoadingContent = isLoadingContent
        self.lastError = lastError
    }

    init(content: ContentType?, isLoadingContent: Bool, lastError: ErrorType?) {

        self.init(statefulContent: .init(content), isLoadingContent: isLoadingContent, lastError: lastError)
    }

    init(_ result: Result<ContentType, ErrorType>) {
        self.init()

        isLoadingContent = false // we aren't loading as we've got the result

        switch result {
        case let .success(content):
            self.statefulContent = .init(content)
            self.lastError = nil
        case let .failure(error):
            self.statefulContent = .empty
            self.lastError = error
        }
    }

    init(withContent content: ContentType) {
        self.init()

        self.isLoadingContent = false
        self.statefulContent = .init(content)
        self.lastError = nil
    }

    init(withError error: ErrorType) {
        self.init()

        self.isLoadingContent = false
        self.statefulContent = .empty
        self.lastError = error
    }
}

// MARK: - Operations

extension LoadableModelProtocol {

    mutating func setLoadingContentStarted() {
        isLoadingContent = true
    }

    mutating func setLoadingContentFinished(_ content: ContentType) {
        setLoadingContentFinished(with: .success(content))
    }

    mutating func setLoadingContentFailed(_ error: ErrorType) {
        setLoadingContentFinished(with: .failure(error))
    }

    mutating func setLoadingContentFinished(with result: Result<ContentType, ErrorType>) {
        isLoadingContent = false

        switch result {

        case let .success(newContent):
            statefulContent = .init(newContent)
            lastError = nil

        case let .failure(newError):
            // do not reset the old statefulContent
            lastError = newError
        }
    }
}

// MARK: - Mapping

extension LoadableModelProtocol {

    func map<T: LoadableModelProtocol>(to: T.Type = T.self, contentMapper: (ContentType) -> T.ContentType?, errorMapper: (ErrorType) -> T.ErrorType?) -> T {

        T(content: statefulContent.get().flatMap(contentMapper),
          isLoadingContent: isLoadingContent,
          lastError: lastError.flatMap(errorMapper))
    }

    func map<T: LoadableModelProtocol>(to: T.Type = T.self, contentMapper: (ContentType) -> T.ContentType?) -> T where ErrorType == T.ErrorType {

        T(content: statefulContent.get().flatMap(contentMapper),
          isLoadingContent: isLoadingContent,
          lastError: lastError)
    }
    
    func map<T: LoadableModelProtocol>(to: T.Type = T.self, errorMapper: (ErrorType) -> T.ErrorType?) -> T where ContentType == T.ContentType {

        T(statefulContent: statefulContent,
          isLoadingContent: isLoadingContent,
          lastError: lastError.flatMap(errorMapper))
    }

    func map<T: LoadableModelProtocol>(to: T.Type = T.self) -> T where ContentType == T.ContentType, ErrorType == T.ErrorType {

        T(statefulContent: statefulContent,
          isLoadingContent: isLoadingContent,
          lastError: lastError)
    }
}
