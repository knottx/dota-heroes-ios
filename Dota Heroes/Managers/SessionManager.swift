//
//  SessionManager.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 18/11/2024.
//

import Foundation
import RxSwift

struct SessionManager {
    static let shared = SessionManager()

    private let bag = DisposeBag()

    @RxPublished private(set) var favoriteIds: [Int] = []

    let addFavorite = PublishSubject<Int>()
    let removeFavorite = PublishSubject<Int>()

    init() {
        let onAddFavorite = self.addFavorite.withLatestFrom(self.$favoriteIds, resultSelector: { $1 + [$0] })
        let onRemoveFavorite = self.removeFavorite.withLatestFrom(self.$favoriteIds, resultSelector: { removeIds, ids in
            return ids.filter { $0 != removeIds }
        })

        let favoriteIds = Observable.merge(onAddFavorite, onRemoveFavorite)
        self._favoriteIds.bindFrom(favoriteIds).disposed(by: self.bag)
    }
}
