//
//  DotaHeroCollectionViewCell.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import UIKit

class DotaHeroCollectionViewCell: UICollectionViewCell {
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var heroAttributeImageView: UIImageView!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.heroNameLabel.text = ""
    }

    override func prepareForReuse() {
        self.heroImageView.image = nil
        self.heroAttributeImageView.image = nil
        self.heroNameLabel.text = ""
        self.favoriteImageView.image = nil
    }

    func configure(with dotaHero: DotaHero, isFavorite: Bool) {
        self.heroImageView.setImage(stringUrl: dotaHero.imageUrl())
        self.heroAttributeImageView.image = dotaHero.primaryAttr?.image
        self.heroNameLabel.text = dotaHero.localizedName
        self.favoriteImageView.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
}
