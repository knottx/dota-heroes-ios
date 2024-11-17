//
//  HomeViewController.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import RxSwift
import Then
import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet var strButton: UIButton!
    @IBOutlet var agiButton: UIButton!
    @IBOutlet var intButton: UIButton!
    @IBOutlet var universalButton: UIButton!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!

    private var viewModel: ViewModel!

    private lazy var setFilteredAttribute = Binder<DotaHeroAttribute?>(self) { s, filteredAttribute in
        s.strButton.alpha = filteredAttribute == .strength ? 1 : 0.5
        s.agiButton.alpha = filteredAttribute == .agility ? 1 : 0.5
        s.intButton.alpha = filteredAttribute == .intelligence ? 1 : 0.5
        s.universalButton.alpha = filteredAttribute == .universal ? 1 : 0.5
    }

    private lazy var setSortType = Binder<SortType>(self) { s, sortType in
        s.sortButton.setImage(sortType == .desc ? UIImage(systemName: "arrow.up") : UIImage(systemName: "arrow.down"), for: .normal)
    }

    private lazy var setShowFavorite = Binder<Bool>(self) { s, showFavorite in
        s.favoriteButton.setImage(showFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }

    private lazy var onSelected = Binder<HomeDotaHero>(self) { _, homeDotaHero in
        let vc = DotaHeroDetailViewController.create(dotaHero: homeDotaHero.dotaHero)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    static func create() -> HomeViewController {
        let vc = self.newInstance(of: self, storyboard: .main)
        let reloader = vc.refresher.rx.controlEvent(.valueChanged).mapVoid()
        vc.viewModel = .init(reloader: reloader)
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    func configureView() {
        self.navigationController?.navigationBar.isHidden = true
        self.collectionView.register(cell: DotaHeroCollectionViewCell.self)
        self.collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.backgroundColor = .clear
        self.collectionView.refreshControl = self.refresher
        self.collectionView.rx.setDelegate(self).disposed(by: self.bag)
    }

    func bind() {
        self.strButton.rx.tap.map { DotaHeroAttribute.strength }.bind(to: self.viewModel.setFilteredAttribute).disposed(by: self.bag)

        self.agiButton.rx.tap.map { DotaHeroAttribute.agility }.bind(to: self.viewModel.setFilteredAttribute).disposed(by: self.bag)

        self.intButton.rx.tap.map { DotaHeroAttribute.intelligence }.bind(to: self.viewModel.setFilteredAttribute).disposed(by: self.bag)

        self.universalButton.rx.tap.map { DotaHeroAttribute.universal }.bind(to: self.viewModel.setFilteredAttribute).disposed(by: self.bag)

        self.sortButton.rx.tap.bind(to: self.viewModel.setSortType).disposed(by: self.bag)

        self.favoriteButton.rx.tap.bind(to: self.viewModel.setShowFavorite).disposed(by: self.bag)

        self.searchTextField.rx.text.orEmpty.bind(to: self.viewModel.setSearchText).disposed(by: self.bag)

        self.collectionView.rx.modelSelected(HomeDotaHero.self)
            .bind(to: self.onSelected).disposed(by: self.bag)

        self.viewModel.$filteredAttribute.drive(self.setFilteredAttribute).disposed(by: self.bag)
        self.viewModel.$sortType.drive(self.setSortType).disposed(by: self.bag)
        self.viewModel.$showFavorites.drive(self.setShowFavorite).disposed(by: self.bag)

        self.viewModel.$dataSource.drive(self.collectionView.rx.items) { collectionView, index, homeDotaHero in
            let indexPath = IndexPath(row: index, section: 0)
            return collectionView.dequeueCell(of: DotaHeroCollectionViewCell.self, for: indexPath).then { cell in
                cell.configure(with: homeDotaHero.dotaHero, isFavorite: homeDotaHero.isFavorite)
            }
        }.disposed(by: self.bag)

        self.viewModel.$isLoading.drive(self.loadingIndicator).disposed(by: self.bag)
        self.viewModel.$isLoading.drive(self.refreshControlBinder).disposed(by: self.bag)
        self.viewModel.$error.drive(self.errorToaster).disposed(by: self.bag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 8
        var cellPerRow: CGFloat = 2
        while width / (cellPerRow + 1) > 180 {
            cellPerRow += 1
        }
        let cellWidth: CGFloat = (width / cellPerRow) - 8
        let cellHeight: CGFloat = cellWidth * 9 / 16
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
