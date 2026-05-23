//
//  PetType.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import Foundation

struct PassiveSkill {
    let name: String
    let description: String
}

enum ActiveSkill: String, CaseIterable, Codable, Identifiable {
    case vajraSuppression
    case vajraShock
    case vajraSmite

    var id: String { rawValue }

    var ownerType: PetType {
        switch self {
        case .vajraSuppression, .vajraShock, .vajraSmite:
            return .vajraGuardian
        }
    }

    var displayName: String {
        switch self {
        case .vajraSuppression:
            return "祭·镇压"
        case .vajraShock:
            return "祭·电击"
        case .vajraSmite:
            return "祭·强击"
        }
    }

    var requiredLevel: Int {
        switch self {
        case .vajraSuppression:
            return 5
        case .vajraShock:
            return 12
        case .vajraSmite:
            return 18
        }
    }

    var cooldownRounds: Int {
        switch self {
        case .vajraSuppression:
            return 5
        case .vajraShock:
            return 3
        case .vajraSmite:
            return 7
        }
    }

    var description: String {
        switch self {
        case .vajraSuppression:
            return "使用石敢当击倒敌人，下一回合敌人无法攻击。冷却 5 回合。"
        case .vajraShock:
            return "召唤金刚放电攻击目标，目标接下来 2 次承伤时防御力降低 20%。冷却 3 回合。"
        case .vajraSmite:
            return "对目标弱点猛击，之后 2 个回合持续流失相当于自身攻击力的生命值。冷却 7 回合。"
        }
    }

    var bookDisplayName: String {
        "\(ownerType.displayName)技能书·\(displayName)"
    }
}

enum PetType: String, CaseIterable, Codable, Identifiable {
    case vajraGuardian
    case rakshasaGuardian
    case swordRanger
    case arcaneRanger
    case fireMage
    case thunderMage
    case celestialTalismanist
    case netherTalismanist

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .vajraGuardian:
            return "金刚力士"
        case .rakshasaGuardian:
            return "罗刹力士"
        case .swordRanger:
            return "驭剑游侠"
        case .arcaneRanger:
            return "奇门游侠"
        case .fireMage:
            return "控火法师"
        case .thunderMage:
            return "掌电法师"
        case .celestialTalismanist:
            return "天君符咒师"
        case .netherTalismanist:
            return "幽冥符咒师"
        }
    }

    var speciesName: String {
        switch self {
        case .vajraGuardian:
            return "近战体修"
        case .rakshasaGuardian:
            return "狂战体修"
        case .swordRanger:
            return "御剑剑修"
        case .arcaneRanger:
            return "机关奇修"
        case .fireMage:
            return "火系法修"
        case .thunderMage:
            return "雷系法修"
        case .celestialTalismanist:
            return "正道符修"
        case .netherTalismanist:
            return "幽冥符修"
        }
    }

    var icon: String {
        switch self {
        case .vajraGuardian:
            return "🛡️"
        case .rakshasaGuardian:
            return "👹"
        case .swordRanger:
            return "🗡️"
        case .arcaneRanger:
            return "🧭"
        case .fireMage:
            return "🔥"
        case .thunderMage:
            return "⚡️"
        case .celestialTalismanist:
            return "📜"
        case .netherTalismanist:
            return "🕯️"
        }
    }

    var portraitAssetName: String? {
        switch self {
        case .vajraGuardian:
            return "VajraGuardianPortrait"
        default:
            return nil
        }
    }

    var purchasePrice: Int {
        switch self {
        case .vajraGuardian:
            return 140
        case .rakshasaGuardian:
            return 170
        case .swordRanger:
            return 210
        case .arcaneRanger:
            return 180
        case .fireMage:
            return 220
        case .thunderMage:
            return 240
        case .celestialTalismanist:
            return 200
        case .netherTalismanist:
            return 230
        }
    }

    var workReward: Int {
        switch self {
        case .vajraGuardian:
            return 22
        case .rakshasaGuardian:
            return 26
        case .swordRanger:
            return 30
        case .arcaneRanger:
            return 28
        case .fireMage:
            return 32
        case .thunderMage:
            return 34
        case .celestialTalismanist:
            return 29
        case .netherTalismanist:
            return 31
        }
    }

    var showsAttackPower: Bool {
        switch self {
        case .fireMage, .thunderMage, .celestialTalismanist, .netherTalismanist:
            return false
        default:
            return true
        }
    }

    var showsSpellPower: Bool {
        switch self {
        case .vajraGuardian, .rakshasaGuardian, .swordRanger, .arcaneRanger:
            return false
        default:
            return true
        }
    }

    var passiveSkill: PassiveSkill? {
        switch self {
        case .vajraGuardian:
            return PassiveSkill(
                name: "金刚护体",
                description: "每过 2 个回合，下一回合受到的伤害降低 30%"
            )
        default:
            return nil
        }
    }

    var starterActiveSkills: [ActiveSkill] {
        ActiveSkill.allCases.filter { $0.ownerType == self }
    }
}
