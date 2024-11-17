//
//  AppContainer.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation

final class AppContainer {
    static let shared = AppContainer()
    
    let sessionManager: SessionManager
    let dotaHeroRepository: DotaHeroRepository
    
    init() {
        self.sessionManager = SessionManagerImpl()
      
        let apiClient: ApiClient = ApiClientImpl()
        self.dotaHeroRepository = DotaHeroRepositoryImpl(DotaHeroRemoteDataSource(apiClient))
    }
}
