//
//  RxSwift+Extension.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Action
import Foundation
import RxCocoa
import RxSwift

public extension ObservableType where Element == [Bool] {
    func atLeastOneTrue() -> Observable<Bool> {
        self.map { !$0.allSatisfy { $0 == false } }
    }
}

public extension ObservableType {
    func asOptional() -> Observable<Element?> {
        return self.map { $0 as Element? }
    }

    func mapVoid() -> Observable<Void> {
        return self.map { _ in () }
    }

    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}

public extension ObservableType where Element: OptionalType {
    func compactMap() -> Observable<Element.Wrapped> {
        return self.compactMap { $0.optional }
    }
}

public extension SharedSequence {
    func asOptional() -> SharedSequence<SharingStrategy, Element?> {
        return self.map { $0 as Element? }
    }

    func mapVoid() -> SharedSequence<SharingStrategy, Void> {
        return self.map { _ in () }
    }

    func withPrevious(startWith first: Element) -> SharedSequence<SharingStrategy, (Element, Element)> {
        return self.scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}

public extension SharedSequence where Element: OptionalType {
    func compactMap() -> SharedSequence<SharingStrategy, Element.Wrapped> {
        return self.compactMap { $0.optional }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    func mapVoid() -> Single<Void> {
        return self.map { _ in () }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait, Element: OptionalType {
    func compactMap() -> Maybe<Element.Wrapped> {
        return self.compactMap { $0.optional }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Self { self }
}

public extension Action {
    /// Finds the deepest error in underlyingErrors
    var error: Observable<Error?> {
        return errors.flatMap { actionError -> Observable<Error?> in
            guard let error = self.mapError(error: actionError) else {
                return Observable.empty()
            }
            return Observable.just(error)
        }
    }

    private func mapError(error: Error) -> Error? {
        if let e = error as? ActionError {
            switch e {
            case let .underlyingError(underlying):
                return self.mapError(error: underlying)
            default:
                return nil
            }
        } else {
            return error
        }
    }
}
