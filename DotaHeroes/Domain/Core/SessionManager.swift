//
//  SessionManager.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift

protocol SessionManager {
    var favorites: Observable<Set<Int>> { get }
    func isFavorite(id: Int) -> Observable<Bool>
    func toggleFavorite(id: Int)
}
