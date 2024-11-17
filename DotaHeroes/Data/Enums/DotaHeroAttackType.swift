//
//  DotaHeroAttackType.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import UIKit

enum DotaHeroAttackType: String, Codable  {
    case melee = "Melee"
    case ranged = "Ranged"

    var image: UIImage? {
        switch self {
        case .melee: return UIImage(named: "melee")
        case .ranged: return UIImage(named: "ranged")
        }
    }
}

