//
//  HomeViewModel.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
 
class HomeViewModel {
    struct Input {
        let refresh: Signal<Void>
        let showFavoritesTap: Signal<Void>
        let attributeTap: Signal<DotaHeroAttribute>
        let sortTypeTap: Signal<Void>
        let setSearchText: Signal<String>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let filteredAttribute: Driver<DotaHeroAttribute?>
        let sortType: Driver<SortType>
        let showFavorites: Driver<Bool>
        let dataSource: Driver<[DotaHero]>
        let error: Signal<Error>
    }
    
    private let sessionManager: SessionManager
    private let dotaHeroRepository: DotaHeroRepository
    
    private let isLoading: BehaviorRelay<Bool> = .init(value: false)
    private let error: PublishRelay<Error> = .init()
    
    private let dotaHeroes: BehaviorRelay<[DotaHero]> = .init(value: [])
    private let sortType: BehaviorRelay<SortType> = .init(value: .asc)
    private let filteredAttribute: BehaviorRelay<DotaHeroAttribute?> = .init(value: nil)
    private let showFavorites: BehaviorRelay<Bool> = .init(value: false)
    private let searchText: BehaviorRelay<String> = .init(value: "")
    private let dataSource: BehaviorRelay<[DotaHero]> = .init(value: [])
    
    private let bag = DisposeBag()

    

    init(sessionManager: SessionManager,
         dotaHeroRepository: DotaHeroRepository) {
        self.sessionManager = sessionManager
        self.dotaHeroRepository = dotaHeroRepository
    }
    
    func transform(_ input: Input) -> Output {
        input.refresh
            .asObservable()
            .bind(onNext: { [weak self] _ in
                guard let self else { return }
                self.getDotaHeroes()
            }).disposed(by: self.bag)
        input.showFavoritesTap
            .asObservable()
            .withLatestFrom(self.showFavorites)
            .map { !$0 }
            .bind(to: self.showFavorites)
            .disposed(by: self.bag)
        
        
        input.attributeTap
            .asObservable()
            .withLatestFrom(self.filteredAttribute, resultSelector: { $0 == $1 ? nil : $0 })
            .bind(to: self.filteredAttribute)
            .disposed(by: self.bag)
       
        input.sortTypeTap
            .asObservable()
            .withLatestFrom(self.sortType)
            .map { $0 == .asc ? .desc : .asc }
            .bind(to: self.sortType)
            .disposed(by: self.bag)
        
        input.setSearchText
            .asObservable()
            .bind(to: self.searchText)
            .disposed(by: self.bag)
        
        Observable.combineLatest(self.dotaHeroes,
                                 self.sortType,
                                 self.filteredAttribute,
                                 self.sessionManager.favorites.asObservable(),
                                 self.showFavorites,
                                 self.searchText)
            .map { dotaHeroes, sortType, filteredAttribute, favoriteIds, showFavorites, searchText in
                var ds: [DotaHero] = dotaHeroes

                switch sortType {
                case .asc:
                    ds = ds.sorted(by: { $0.localizedName ?? "" < $1.localizedName ?? "" })
                case .desc:
                    ds = ds.sorted(by: { $1.localizedName ?? "" < $0.localizedName ?? "" })
                }

                if let filteredAttribute = filteredAttribute {
                    ds = ds.filter { $0.primaryAttr == filteredAttribute }
                }

                if !searchText.isEmpty {
                    ds = ds.filter { $0.localizedName?.lowercased().contains(searchText.lowercased()) ?? false }
                }

                if showFavorites && !favoriteIds.isEmpty {
                    ds = ds.filter {
                        if let id = $0.id {
                            return favoriteIds.contains(id)
                        } else {
                            return false
                        }
                    }
                }

                return ds
            }
            .bind(to: self.dataSource).disposed(by:  self.bag)
        
        return Output(
            isLoading: self.isLoading.asDriver(),
            filteredAttribute: self.filteredAttribute.asDriver(),
            sortType: self.sortType.asDriver(),
            showFavorites: self.showFavorites.asDriver(),
            dataSource: self.dataSource.asDriver(),
            error: self.error.asSignal()
        )
    }
    
    func getDotaHeroes() {
        self.isLoading.accept(true)
        self.dotaHeroRepository.getHeroStats().subscribe(onSuccess: { data in
            self.isLoading.accept(false)
            self.dotaHeroes.accept(data)
        }, onFailure: { error in
            self.isLoading.accept(false)
            self.error.accept(error)
        }).disposed(by: self.bag)
    }
    
     
    func favoriteDriver(for id: Int?) -> Driver<Bool> {
        guard let id = id else { return .just(false) }
        return self.sessionManager.isFavorite(id: id)
            .asDriver(onErrorDriveWith: .empty())
    }
}
