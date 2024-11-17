//
//  DotaHero.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation

struct DotaHero: Codable, Equatable {
    let id: Int?
    let name: String?
    let localizedName: String?
    let primaryAttr: DotaHeroAttribute?
    let attackType: DotaHeroAttackType?
    let roles: [DotaHeroRole?]?
    let img: String?
    let icon: String?
    let baseHealth: Double?
    let baseHealthRegen: Double?
    let baseMana: Double?
    let baseManaRegen: Double?
    let baseArmor: Double?
    let baseMr: Double?
    let baseAttackMin: Double?
    let baseAttackMax: Double?
    let baseStr: Double?
    let baseAgi: Double?
    let baseInt: Double?
    let strGain: Double?
    let agiGain: Double?
    let intGain: Double?
    let attackRange: Double?
    let projectileSpeed: Double?
    let attackRate: Double?
    let baseAttackTime: Double?
    let attackPoint: Double?
    let moveSpeed: Double?
    let turnRate: Double?
    let cmEnabled: Bool?
    let legs: Int?
    let dayVision: Double?
    let nightVision: Double?

    func portraitImageUrl() -> String {
        guard let path = img?.replacingOccurrences(of: "/apps/dota2/images/dota_react/heroes/",
                                                   with: "/apps/dota2/videos/dota_react/heroes/renders/") else {
            return AppConstants.imageBaseUrl
        }
        return AppConstants.imageBaseUrl + path
    }

    func portraitVideoUrl() -> String {
        return self.portraitImageUrl().replacingOccurrences(of: ".png", with: ".webm")
    }

    func imageUrl() -> String {
        return AppConstants.imageBaseUrl + (self.img ?? "")
    }

    func health() -> Double {
        return (self.baseHealth ?? 0) + ((self.baseStr ?? 0) * 20.0)
    }

    func healthRegen() -> Double {
        return (self.baseHealthRegen ?? 0) + ((self.baseStr ?? 0) * 0.1)
    }

    func mana() -> Double {
        return (self.baseMana ?? 0) + ((self.baseInt ?? 0) * 12.0)
    }

    func manaRegen() -> Double {
        return (self.baseManaRegen ?? 0) + ((self.baseInt ?? 0) * 0.05)
    }

    func armor() -> Double {
        return (self.baseArmor ?? 0) + ((self.baseAgi ?? 0) * 0.167)
    }

    func attackMin() -> Double {
        let baseAttack = self.baseAttackMin ?? 0
        let baseStrength = self.baseStr ?? 0
        let baseAgility = self.baseAgi ?? 0
        let baseIntelligence = self.baseInt ?? 0

        switch self.primaryAttr {
        case .strength:
            return baseAttack + baseStrength
        case .agility:
            return baseAttack + baseAgility
        case .intelligence:
            return baseAttack + baseIntelligence
        case .universal:
            return baseAttack +
                (baseStrength * 0.6) +
                (baseAgility * 0.6) +
                (baseIntelligence * 0.6)
        default:
            return baseAttack
        }
    }

    func attackMax() -> Double {
        let baseAttack = self.baseAttackMax ?? 0
        let baseStrength = self.baseStr ?? 0
        let baseAgility = self.baseAgi ?? 0
        let baseIntelligence = self.baseInt ?? 0

        switch self.primaryAttr {
        case .strength:
            return baseAttack + baseStrength
        case .agility:
            return baseAttack + baseAgility
        case .intelligence:
            return baseAttack + baseIntelligence
        case .universal:
            return baseAttack +
                (baseStrength * 0.6) +
                (baseAgility * 0.6) +
                (baseIntelligence * 0.6)
        default:
            return baseAttack
        }
    }
}
