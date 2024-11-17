//
//  DotaHeroRemoteDataSource.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation
import RxSwift

class DotaHeroRemoteDataSource {
    private let apiClient: ApiClient
    
    init(_ apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getHeroStats() -> Single<[DotaHero]> {
        let path = "/api/heroStats"
        return self.apiClient.requestDecodable(path, method: .get, params: nil)
    }
}
