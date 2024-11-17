//
//  HomeViewController.ViewModel.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Action
import Foundation
import RxSwift

extension HomeViewController {
    struct ViewModel {
        private let bag = DisposeBag()

        @RxPublished private(set) var dotaHeroes: [DotaHero] = []
        @RxPublished private(set) var sortType: SortType = .asc
        @RxPublished private(set) var filteredAttribute: DotaHeroAttribute?
        @RxPublished private(set) var showFavorites: Bool = false
        @RxPublished private(set) var searchText: String = ""

        @RxPublished private(set) var dataSource: [HomeDotaHero] = []

        @RxPublished private(set) var isLoading: Bool = false
        @RxPublishedSubject private(set) var error: Error

        let onReload = PublishSubject<Void>()

        let setFilteredAttribute = PublishSubject<DotaHeroAttribute>()
        let setSortType = PublishSubject<Void>()
        let setShowFavorite = PublishSubject<Void>()
        let setSearchText = PublishSubject<String>()

        private lazy var getHotaHeroes = Action<Void, [DotaHero]> {
            return DotaHeroAPI.getHeroStats()
        }

        init(reloader: Observable<Void>) {
            let filteredAttribute = self.setFilteredAttribute
                .withLatestFrom(self.$filteredAttribute,
                                resultSelector: { $0 == $1 ? nil : $0 })
            self._filteredAttribute.bindFrom(filteredAttribute).disposed(by: self.bag)

            self._dotaHeroes.bindFrom(self.getHotaHeroes.elements).disposed(by: self.bag)

            let sortType = self.setSortType
                .withLatestFrom(self.$sortType)
                .map { $0 == SortType.asc ? SortType.desc : SortType.asc }
            self._sortType.bindFrom(sortType).disposed(by: self.bag)

            let showFavorite = self.setShowFavorite
                .withLatestFrom(self.$showFavorites)
                .map { !$0 }
            self._showFavorites.bindFrom(showFavorite).disposed(by: self.bag)

            self._searchText.bindFrom(self.setSearchText).disposed(by: self.bag)

            let dataSource = Observable.combineLatest(self.$dotaHeroes.asObservable(),
                                                      self.$sortType.asObservable(),
                                                      self.$filteredAttribute.asObservable(),
                                                      SessionManager.shared.$favoriteIds.asObservable(),
                                                      self.$showFavorites.asObservable(),
                                                      self.$searchText.asObservable())
                .map { dotaHeroes, sortType, filteredAttribute, favoriteIds, showFavorites, searchText in
                    var ds: [HomeDotaHero] = dotaHeroes
                        .map { HomeDotaHero(isFavorite: ($0.id != nil) ? favoriteIds.contains($0.id!) : false,
                                            dotaHero: $0) }

                    switch sortType {
                    case .asc:
                        ds = ds.sorted(by: { $0.dotaHero.localizedName ?? "" < $1.dotaHero.localizedName ?? "" })
                    case .desc:
                        ds = ds.sorted(by: { $1.dotaHero.localizedName ?? "" < $0.dotaHero.localizedName ?? "" })
                    }

                    if let filteredAttribute = filteredAttribute {
                        ds = ds.filter { $0.dotaHero.primaryAttr == filteredAttribute }
                    }

                    if !searchText.isEmpty {
                        ds = ds.filter { $0.dotaHero.localizedName?.lowercased().contains(searchText.lowercased()) ?? false }
                    }

                    if showFavorites && !favoriteIds.isEmpty {
                        ds = ds.filter { $0.isFavorite }
                    }

                    return ds
                }

            self._dataSource.bindFrom(dataSource).disposed(by: self.bag)

            self._isLoading.bindFrom(self.getHotaHeroes.executing).disposed(by: self.bag)

            self._error.bindFrom(self.getHotaHeroes.error.compactMap()).disposed(by: self.bag)

            reloader.startWith(()).bind(to: self.getHotaHeroes.inputs).disposed(by: self.bag)
        }
    }
}
