//
//  DotaHeroAPI.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Foundation
import RxSwift

enum DotaHeroAPI {
    static func getHeroStats() -> Single<[DotaHero]> {
        return APIClient.shared.request(path: "/api/heroStats")
    }
}
