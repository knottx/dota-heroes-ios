//
//  DotaHeroCollectionViewCell.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import UIKit
import RxSwift
import RxCocoa

class DotaHeroCollectionViewCell: UICollectionViewCell {
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var heroAttributeImageView: UIImageView!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!

    var bag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.heroNameLabel.text = ""
        self.favoriteImageView.image = UIImage(systemName: "heart.fill")
        self.favoriteImageView.isHidden = true
    }

    override func prepareForReuse() {
        self.bag = DisposeBag()
        self.heroImageView.image = nil
        self.heroAttributeImageView.image = nil
        self.heroNameLabel.text = ""
        self.favoriteImageView.isHidden = true
    }

    func configure(with dotaHero: DotaHero, isFavorite: Driver<Bool>) {
        self.heroImageView.setImage(stringUrl: dotaHero.imageUrl())
        self.heroAttributeImageView.image = dotaHero.primaryAttr?.image
        self.heroNameLabel.text = dotaHero.localizedName
        
        isFavorite.map { !$0 }
            .drive(self.favoriteImageView.rx.isHidden)
            .disposed(by: self.bag)
    }
}
