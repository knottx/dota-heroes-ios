//
//  RxPublished.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Foundation
import RxCocoa
import RxSwift

@propertyWrapper class RxPublished<Value> {
    var relayValue: BehaviorRelay<Value>

    var wrappedValue: Value {
        get {
            return self.relayValue.value
        }
        set {
            self.relayValue.accept(newValue)
        }
    }

    var projectedValue: Driver<Value> { self.relayValue.asDriver() }

    init(wrappedValue: Value) {
        self.relayValue = BehaviorRelay<Value>(value: wrappedValue)
    }

    func bindFrom(_ from: Observable<Value>) -> Disposable {
        from.bind(to: self.relayValue)
    }

    func bindFrom(_ from: Driver<Value>) -> Disposable {
        from.drive(self.relayValue)
    }
}
