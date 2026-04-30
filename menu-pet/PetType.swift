//
//  PetType.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import Foundation

enum PetType: String, CaseIterable, Codable, Identifiable {
    case xiaoHua
    case xiaoBai
    case fox
    case hermitCrab

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .xiaoHua:
            return "小花"
        case .xiaoBai:
            return "小白"
        case .fox:
            return "狐狸"
        case .hermitCrab:
            return "寄居蟹"
        }
    }

    var speciesName: String {
        switch self {
        case .xiaoHua:
            return "花猫"
        case .xiaoBai:
            return "京巴犬"
        case .fox:
            return "狐狸"
        case .hermitCrab:
            return "寄居蟹"
        }
    }

    var icon: String {
        switch self {
        case .xiaoHua:
            return "🐱"
        case .xiaoBai:
            return "🐶"
        case .fox:
            return "🦊"
        case .hermitCrab:
            return "🦀"
        }
    }

    var purchasePrice: Int {
        switch self {
        case .xiaoHua:
            return 120
        case .xiaoBai:
            return 160
        case .fox:
            return 220
        case .hermitCrab:
            return 90
        }
    }

    var salePrice: Int {
        switch self {
        case .xiaoHua:
            return 80
        case .xiaoBai:
            return 110
        case .fox:
            return 150
        case .hermitCrab:
            return 60
        }
    }

    var workReward: Int {
        switch self {
        case .xiaoHua:
            return 20
        case .xiaoBai:
            return 24
        case .fox:
            return 30
        case .hermitCrab:
            return 16
        }
    }

    func moodEmoji(mood: Int, satiety: Int, energy: Int) -> String {
        if energy < 20 {
            return tiredEmoji
        }

        if satiety < 20 {
            return hungryEmoji
        }

        if mood > 75 {
            return happyEmoji
        }

        if mood < 35 {
            return sadEmoji
        }

        return idleEmoji
    }

    private var idleEmoji: String {
        "🙂"
    }

    private var happyEmoji: String {
        "😄"
    }

    private var hungryEmoji: String {
        "🥺"
    }

    private var tiredEmoji: String {
        "😴"
    }

    private var sadEmoji: String {
        "😟"
    }
}
