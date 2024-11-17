//
//  DotaHeroDetailViewController.ViewModel.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 18/11/2024.
//

import Foundation
import RxSwift

extension DotaHeroDetailViewController {
    struct ViewModel {
        private let bag = DisposeBag()

        @RxPublished private(set) var dotaHeroe: DotaHero?

        init(dotaHero: DotaHero) {
            self.dotaHeroe = dotaHero
        }
    }
}
