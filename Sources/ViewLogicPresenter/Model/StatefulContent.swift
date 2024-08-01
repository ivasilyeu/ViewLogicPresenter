//
//  StatefulContent.swift
//
//  Created by IV on 01.12.2016.
//

// MARK: - StatefulContent

enum StatefulContent<T>: ExpressibleByNilLiteral {

    init(nilLiteral: ()) {
        self = .empty
    }

    case empty
    case some(T)
}

extension StatefulContent: Hashable where T: Hashable {}

extension StatefulContent: Equatable where T: Equatable {}

extension StatefulContent {

    init(_ content: T?) {
        self = content.map { .some($0) } ?? .empty
    }
}

extension StatefulContent where T: Collection {

    init(_ content: T) {
        self = content.isEmpty ? .empty : .some(content)
    }
}

extension StatefulContent {

    /**
     Returns the content model value or `nil` if there's none.

     Use this method to retrieve the value of this content if it has some.

     - Returns: The content model value, if the instance contains one, `nil` otherwise.
     */
    @inlinable func get() -> T? {
        switch self {
        case .some(let content):
            return content
        case .empty:
            return nil
        }
    }
}
