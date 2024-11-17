//
//  UIViewController+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation
import UIKit

extension UIViewController {
    class func newInstance<T: UIViewController>(of: T.Type, storyboard: Storyboard) -> T {
        let identifier = String(describing: self)
        return UIStoryboard(name: storyboard.rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: identifier) as! T
    }
}
