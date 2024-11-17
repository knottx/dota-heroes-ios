//
//  DotaHeroDetailViewController.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift
import RxCocoa
import UIKit

class DotaHeroDetailViewController: BaseViewController {
    @IBOutlet var heroPrimaryAttrImageView: UIImageView!
    @IBOutlet var heroPrimaryAttrLabel: UILabel!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var heroAttackTypeImageView: UIImageView!
    @IBOutlet var heroAttackTypeLabel: UILabel!
    @IBOutlet var heroImageView: UIImageView!

    private var viewModel: DotaHeroViewModel!
    
    private let favoriteButton = UIButton(type: .system)
    
    

    static func create(dotaHero: DotaHero) -> DotaHeroDetailViewController {
        let vc = self.newInstance(of: self, storyboard: .main)
        vc.viewModel = .init(sessionManager: AppContainer.shared.sessionManager,
                             dotaHero: dotaHero)
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }

    func configure() {
        let dotaHero = self.viewModel.dotaHero
        self.heroPrimaryAttrImageView.image = dotaHero.primaryAttr?.image
        self.heroPrimaryAttrLabel.text = dotaHero.primaryAttr?.title
        self.heroNameLabel.text = dotaHero.localizedName?.uppercased()
        self.heroAttackTypeImageView.image = dotaHero.attackType?.image
        self.heroAttackTypeLabel.text = dotaHero.attackType?.rawValue.uppercased()
        self.heroImageView.setImage(stringUrl: dotaHero.portraitImageUrl())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.favoriteButton)
    }

    func bind() {
        let input = DotaHeroViewModel.Input(
            favoriteTap: self.favoriteButton.rx.tap.asSignal()
        )
                
        let output = self.viewModel.transform(input)

        output.isFavorite
            .map { UIImage(systemName: $0 ? "heart.fill" : "heart") }
            .drive(favoriteButton.rx.image(for: .normal))
            .disposed(by: self.bag)
    }
 
}
