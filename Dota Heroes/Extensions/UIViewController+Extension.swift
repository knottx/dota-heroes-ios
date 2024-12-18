//
//  UIViewController+Extension.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
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
