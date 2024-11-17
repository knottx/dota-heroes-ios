//
//  DotaHeroDetailViewController.ViewModel.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation
import RxCocoa
import RxSwift

class DotaHeroViewModel {
    struct Input {
        let favoriteTap: Signal<Void>
    }
    
    struct Output {
        let isFavorite: Driver<Bool>
    }
    
    private let sessionManager: SessionManager
    let dotaHero: DotaHero
    
    private let bag = DisposeBag()
    
    init(sessionManager: SessionManager,
         dotaHero: DotaHero) {
        self.sessionManager = sessionManager
        self.dotaHero = dotaHero
    }
    
    func transform(_ input: Input) -> Output {
        guard let heroId = self.dotaHero.id else {
            return Output(isFavorite: .just(false))
        }
        
        let sessionManager = self.sessionManager
        
        input.favoriteTap
            .emit(onNext: { [sessionManager] in
                sessionManager.toggleFavorite(id: heroId)
            }).disposed(by: self.bag)
        
        let isFavorite = self.sessionManager.isFavorite(id: heroId)
            .asDriver(onErrorDriveWith: .just(false))
        
        return Output(isFavorite: isFavorite)
    }
}
