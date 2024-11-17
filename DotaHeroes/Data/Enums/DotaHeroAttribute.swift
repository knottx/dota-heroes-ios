//
//  DotaHeroAttribute.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import UIKit

enum DotaHeroAttribute: String, Codable {
    case strength = "str"
    case agility = "agi"
    case intelligence = "int"
    case universal = "all"

    var image: UIImage? {
        switch self {
        case .strength: return UIImage(named: "hero_strength")
        case .agility: return UIImage(named: "hero_agility")
        case .intelligence: return UIImage(named: "hero_intelligence")
        case .universal: return UIImage(named: "hero_universal")
        }
    }

    var title: String? {
        switch self {
        case .strength: return "Strength"
        case .agility: return "Agility"
        case .intelligence: return "Intelligence"
        case .universal: return "Universal"
        }
    }
}
