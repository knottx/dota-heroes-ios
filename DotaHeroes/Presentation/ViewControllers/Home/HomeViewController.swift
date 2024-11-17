//
//  HomeViewController.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift 
import UIKit
import RxCocoa

class HomeViewController: BaseViewController {
    @IBOutlet var strButton: UIButton!
    @IBOutlet var agiButton: UIButton!
    @IBOutlet var intButton: UIButton!
    @IBOutlet var universalButton: UIButton!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!

    private var viewModel: HomeViewModel!

    private lazy var filteredAttributeBinder = Binder<DotaHeroAttribute?>(self) { s, filteredAttribute in
        s.strButton.alpha = filteredAttribute == .strength ? 1 : 0.5
        s.agiButton.alpha = filteredAttribute == .agility ? 1 : 0.5
        s.intButton.alpha = filteredAttribute == .intelligence ? 1 : 0.5
        s.universalButton.alpha = filteredAttribute == .universal ? 1 : 0.5
    }
 
    class func create() -> HomeViewController {
        let vc = self.newInstance(of: self, storyboard: .main)
        vc.viewModel = .init(sessionManager: AppContainer.shared.sessionManager,
                             dotaHeroRepository:  AppContainer.shared.dotaHeroRepository)
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
        self.viewModel.getDotaHeroes()
    }

    func configure() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.collectionView.register(cell: DotaHeroCollectionViewCell.self)
        self.collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.backgroundColor = .clear
        self.collectionView.refreshControl = self.refresher
        self.collectionView.rx.setDelegate(self).disposed(by: self.bag)
    }

    func bind() {
        let attributeTap = Signal.merge(
            self.strButton.rx.tap.asSignal().map { DotaHeroAttribute.strength },
            self.agiButton.rx.tap.asSignal().map { DotaHeroAttribute.agility },
            self.intButton.rx.tap.asSignal().map { DotaHeroAttribute.intelligence },
            self.universalButton.rx.tap.asSignal().map { DotaHeroAttribute.universal }
        )
        
        let setSearchText = self.searchTextField.rx.text.orEmpty
            .asSignal(onErrorSignalWith: .empty())
        
        let input = HomeViewModel.Input(
            refresh: self.refresher.rx.controlEvent(.valueChanged).asSignal(),
            showFavoritesTap: self.favoriteButton.rx.tap.asSignal(),
            attributeTap: attributeTap,
            sortTypeTap: self.sortButton.rx.tap.asSignal(),
            setSearchText: setSearchText
        )

        let output = self.viewModel.transform(input)

        output.isLoading
            .drive(self.loadingIndicator)
            .disposed(by: self.bag)
        
        output.error
            .asObservable()
            .bind(to: self.errorToaster)
            .disposed(by: self.bag)
        
        output.filteredAttribute
            .drive(self.filteredAttributeBinder)
            .disposed(by: self.bag)

        output.sortType
            .map { UIImage(systemName: $0 == .asc ? "arrow.down" : "arrow.up") }
            .drive(self.sortButton.rx.image(for: .normal))
            .disposed(by: self.bag)
        
        output.showFavorites
            .map { UIImage(systemName: $0 ? "heart.fill" : "heart") }
            .drive(favoriteButton.rx.image(for: .normal))
            .disposed(by: self.bag)
        
        output.dataSource
            .drive(self.collectionView.rx.items(
                cellIdentifier: "DotaHeroCollectionViewCell",
                cellType: DotaHeroCollectionViewCell.self
            )) { [weak self] _, dotaHero, cell in
                guard let vm = self?.viewModel else { return }
                cell.configure(with: dotaHero,
                               isFavorite: vm.favoriteDriver(for: dotaHero.id))
            }
            .disposed(by: self.bag)
             
        
        self.collectionView.rx.modelSelected(DotaHero.self)
            .withUnretained(self)
            .bind { s, dotaHero in
                let vc = DotaHeroDetailViewController.create(dotaHero: dotaHero)
                s.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: self.bag)
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
