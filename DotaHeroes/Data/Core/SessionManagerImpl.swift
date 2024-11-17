//
//  SessionManagerImpl.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift
import RxCocoa

class SessionManagerImpl: SessionManager {
    private let favoritesRelay = BehaviorRelay<Set<Int>>(value: [])

   var favorites: Observable<Set<Int>> {
       self.favoritesRelay.asObservable().distinctUntilChanged()
   }

   func isFavorite(id: Int) -> Observable<Bool> {
       self.favorites.map { $0.contains(id) }.distinctUntilChanged()
   }

    func toggleFavorite(id: Int) {
        var set = favoritesRelay.value
        if set.contains(id) { set.remove(id) } else { set.insert(id) }
        favoritesRelay.accept(set)
    }
}
