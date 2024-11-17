//
//  DotaHeroRepository.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift

protocol DotaHeroRepository {
    func getHeroStats() -> Single<[DotaHero]>
}
