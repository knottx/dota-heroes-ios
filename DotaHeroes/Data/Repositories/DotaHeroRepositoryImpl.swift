//
//  DotaHeroRepository.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift

class DotaHeroRepositoryImpl: DotaHeroRepository {
    private let remote: DotaHeroRemoteDataSource
    
    init(_ remote: DotaHeroRemoteDataSource) {
        self.remote = remote
    }
    
    func getHeroStats() -> Single<[DotaHero]> {
        return self.remote.getHeroStats()
    }
}
