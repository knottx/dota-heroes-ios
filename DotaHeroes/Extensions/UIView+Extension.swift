//
//  UIView+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import UIKit

extension UIView {
    class func identifier() -> String {
        return String(describing: self)
    }

    class func loadFromNib<T: UIView>(of type: T.Type) -> T {
        return UINib(nibName: self.identifier(), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! T
    }
}
