//
//  DotaHeroDetailViewController.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import RxSwift
import UIKit

class DotaHeroDetailViewController: BaseViewController {
    @IBOutlet var heroPrimaryAttrImageView: UIImageView!
    @IBOutlet var heroPrimaryAttrLabel: UILabel!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var heroAttackTypeImageView: UIImageView!
    @IBOutlet var heroAttackTypeLabel: UILabel!
    @IBOutlet var heroImageView: UIImageView!

    var viewModel: ViewModel!

    private lazy var setDetail = Binder<DotaHero?>(self) { s, dotaHero in
        s.heroPrimaryAttrImageView.image = dotaHero?.primaryAttr?.image
        s.heroPrimaryAttrLabel.text = dotaHero?.primaryAttr?.title
        s.heroNameLabel.text = dotaHero?.localizedName?.uppercased()
        s.heroAttackTypeImageView.image = dotaHero?.attackType?.image
        s.heroAttackTypeLabel.text = dotaHero?.attackType?.rawValue.uppercased()
        s.heroImageView.setImage(stringUrl: dotaHero?.portraitImageUrl())
    }

    private lazy var setFavorite = Binder<Bool>(self) { s, isFav in
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: isFav ? "heart.fill" : "heart"),
                                             style: .plain,
                                             target: s,
                                             action: #selector(s.onTapFavorite))
        s.navigationItem.rightBarButtonItem = favoriteButton
    }

    static func create(dotaHero: DotaHero) -> DotaHeroDetailViewController {
        let vc = self.newInstance(of: self, storyboard: .main)
        vc.viewModel = .init(dotaHero: dotaHero)
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }

    func configureView() {}

    func bind() {
        self.viewModel.$dotaHeroe.drive(self.setDetail).disposed(by: self.bag)
        let isFavorite = Observable.combineLatest(self.viewModel.$dotaHeroe.asObservable(),
                                                  SessionManager.shared.$favoriteIds.asObservable())
            .map { dotaHero, favoriteIds in
                if let id = dotaHero?.id, favoriteIds.contains(id) {
                    return true
                } else {
                    return false
                }
            }

        isFavorite.bind(to: self.setFavorite).disposed(by: self.bag)
    }

    @objc func onTapFavorite() {
        if let id = self.viewModel.dotaHeroe?.id {
            SessionManager.shared.addFavorite.onNext(id)
        }
    }
}
