//
//  RxPublishedSubject.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Foundation
import RxCocoa
import RxSwift

@propertyWrapper class RxPublishedSubject<Value> {
    var subjectValue: PublishSubject<Value>

    var wrappedValue: Value {
        @available(*, unavailable)
        get {
            fatalError("You cannot read from this object.")
        }
        set(v) {
            self.subjectValue.onNext(v)
        }
    }

    var projectedValue: Driver<Value> { self.subjectValue.asDriver(onErrorRecover: { _ in return .empty() }) }

    init() {
        self.subjectValue = PublishSubject<Value>()
    }

    func bindFrom(_ from: Observable<Value>) -> Disposable {
        from.bind(to: self.subjectValue)
    }

    func bindFrom(_ from: Driver<Value>) -> Disposable {
        from.drive(self.subjectValue)
    }
}
