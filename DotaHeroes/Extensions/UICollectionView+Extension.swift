//
//  UICollectionView+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import UIKit

extension UICollectionView {
    func scrollToTop(animated: Bool = true) {
        guard self.numberOfSections > 0,
              self.numberOfItems(inSection: 0) > 0 else { return }
        self.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: animated)
    }

    func register(cell: UICollectionViewCell.Type) {
        let nib = UINib(nibName: cell.identifier(), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cell.identifier())
    }

    func register(cells: [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(cell: cell)
        }
    }

    func register(of kind: String, classType: UICollectionReusableView.Type) {
        let nib = UINib(nibName: classType.identifier(), bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: classType.identifier())
    }

    func dequeueCell<T: UICollectionViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }

    func dequeueHeaderSupplementaryView<T: UICollectionReusableView>(of type: T.Type, for indexPath: IndexPath) -> T {
        let kind = UICollectionView.elementKindSectionHeader
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }

    func dequeueFooterSupplementaryView<T: UICollectionReusableView>(of type: T.Type, for indexPath: IndexPath) -> T {
        let kind = UICollectionView.elementKindSectionFooter
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }
}
