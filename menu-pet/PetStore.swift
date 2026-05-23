//
//  PetStore.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import Combine
import Foundation

enum InventoryItem: String, CaseIterable, Codable, Identifiable {
    case bruiseMedicine
    case revivalPill
    case revivalWater
    case essence
    case vajraSuppressionBook
    case vajraShockBook
    case vajraSmiteBook
    case expPill1000
    case expPill2000
    case expPill3000
    case expPill4000
    case expPill5000
    case expPill6000
    case expPill7000
    case expPill8000
    case expPill9000
    case expPill10000

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bruiseMedicine:
            return "跌打药"
        case .revivalPill:
            return "续命丹"
        case .revivalWater:
            return "回生水"
        case .essence:
            return "妖怪精魄"
        case .vajraSuppressionBook:
            return ActiveSkill.vajraSuppression.bookDisplayName
        case .vajraShockBook:
            return ActiveSkill.vajraShock.bookDisplayName
        case .vajraSmiteBook:
            return ActiveSkill.vajraSmite.bookDisplayName
        case .expPill1000:
            return "经验丹·1000"
        case .expPill2000:
            return "经验丹·2000"
        case .expPill3000:
            return "经验丹·3000"
        case .expPill4000:
            return "经验丹·4000"
        case .expPill5000:
            return "经验丹·5000"
        case .expPill6000:
            return "经验丹·6000"
        case .expPill7000:
            return "经验丹·7000"
        case .expPill8000:
            return "经验丹·8000"
        case .expPill9000:
            return "经验丹·9000"
        case .expPill10000:
            return "经验丹·10000"
        }
    }

    var icon: String {
        switch self {
        case .bruiseMedicine:
            return "🩹"
        case .revivalPill:
            return "💊"
        case .revivalWater:
            return "🧴"
        case .essence:
            return "✨"
        case .vajraSuppressionBook, .vajraShockBook, .vajraSmiteBook:
            return "📘"
        default:
            return "🧪"
        }
    }

    var purchasePrice: Int? {
        switch self {
        case .bruiseMedicine:
            return 450
        case .revivalPill:
            return 3600
        case .revivalWater:
            return 200
        case .essence:
            return 40
        default:
            return nil
        }
    }

    var injuryRecovery: Int {
        switch self {
        case .bruiseMedicine:
            return 15
        default:
            return 0
        }
    }

    var experienceGain: Int {
        switch self {
        case .expPill1000:
            return 1_000
        case .expPill2000:
            return 2_000
        case .expPill3000:
            return 3_000
        case .expPill4000:
            return 4_000
        case .expPill5000:
            return 5_000
        case .expPill6000:
            return 6_000
        case .expPill7000:
            return 7_000
        case .expPill8000:
            return 8_000
        case .expPill9000:
            return 9_000
        case .expPill10000:
            return 10_000
        default:
            return 0
        }
    }

    var detailText: String {
        if injuryRecovery > 0 {
            return "恢复 \(injuryRecovery) 点受伤值"
        }

        if self == .revivalPill {
            return "死亡时可立即复活"
        }

        if self == .revivalWater {
            return "回复 50% 生命值，冷却 5 回合"
        }

        if let skill = skillBook {
            return "学习技能：\(skill.displayName)，需求等级 Lv.\(skill.requiredLevel)"
        }

        if experienceGain > 0 {
            return "使用后获得 \(experienceGain) 点经验"
        }

        return "可作为常规掉落素材"
    }

    var isUsable: Bool {
        self != .essence
    }

    var skillBook: ActiveSkill? {
        switch self {
        case .vajraSuppressionBook:
            return .vajraSuppression
        case .vajraShockBook:
            return .vajraShock
        case .vajraSmiteBook:
            return .vajraSmite
        default:
            return nil
        }
    }

    static var merchantCases: [InventoryItem] {
        [.bruiseMedicine, .revivalPill, .revivalWater, .essence]
    }

    static var experiencePills: [InventoryItem] {
        [
            .expPill1000, .expPill2000, .expPill3000, .expPill4000, .expPill5000,
            .expPill6000, .expPill7000, .expPill8000, .expPill9000, .expPill10000
        ]
    }
}

enum EquipmentItem: String, CaseIterable, Codable, Identifiable {
    case noviceHat
    case noviceRobe
    case novicePants
    case noviceWeapon

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .noviceHat:
            return "新手帽子"
        case .noviceRobe:
            return "新手衣服"
        case .novicePants:
            return "新手裤子"
        case .noviceWeapon:
            return "新手武器"
        }
    }

    var icon: String {
        switch self {
        case .noviceHat:
            return "🎩"
        case .noviceRobe:
            return "🥋"
        case .novicePants:
            return "🩳"
        case .noviceWeapon:
            return "🗡️"
        }
    }

    var slotName: String {
        switch self {
        case .noviceHat:
            return "帽子"
        case .noviceRobe:
            return "衣服"
        case .novicePants:
            return "裤子"
        case .noviceWeapon:
            return "武器"
        }
    }

    var slot: EquipmentSlot {
        switch self {
        case .noviceHat:
            return .hat
        case .noviceRobe:
            return .robe
        case .novicePants:
            return .pants
        case .noviceWeapon:
            return .weapon
        }
    }

    var bonusHealth: Int {
        switch self {
        case .noviceHat:
            return 12
        case .noviceRobe:
            return 20
        case .novicePants:
            return 16
        case .noviceWeapon:
            return 0
        }
    }

    var bonusAttack: Int {
        switch self {
        case .noviceWeapon:
            return 4
        default:
            return 0
        }
    }

    var bonusSpell: Int {
        switch self {
        case .noviceWeapon:
            return 4
        default:
            return 0
        }
    }

    var bonusDefense: Int {
        switch self {
        case .noviceHat:
            return 1
        case .noviceRobe:
            return 2
        case .novicePants:
            return 1
        case .noviceWeapon:
            return 0
        }
    }

    var statSummary: String {
        [
            bonusHealth > 0 ? "生命值 +\(bonusHealth)" : nil,
            bonusAttack > 0 ? "攻击力 +\(bonusAttack)" : nil,
            bonusSpell > 0 ? "法术效果 +\(bonusSpell)" : nil,
            bonusDefense > 0 ? "防御力 +\(bonusDefense)" : nil
        ]
        .compactMap { $0 }
        .joined(separator: "\n")
    }
}

enum EquipmentSlot: String, CaseIterable, Codable, Identifiable {
    case hat
    case robe
    case pants
    case weapon

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hat:
            return "帽子"
        case .robe:
            return "衣服"
        case .pants:
            return "裤子"
        case .weapon:
            return "武器"
        }
    }
}

enum HuntMap: String, CaseIterable, Codable, Identifiable {
    case mulberryVillage
    case ninghaiCounty
    case shitangCounty

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .mulberryVillage:
            return "小桑村"
        case .ninghaiCounty:
            return "宁海县"
        case .shitangCounty:
            return "石塘县"
        }
    }

    var levelText: String {
        let range = MonsterDataStore.catalog.levelRange(for: self)
        return "\(range.lowerBound)-\(range.upperBound)级怪物"
    }

    var levelRange: ClosedRange<Int> {
        MonsterDataStore.catalog.levelRange(for: self)
    }

    var subLocations: [String] {
        switch self {
        case .mulberryVillage:
            return ["土地庙", "狐狸坡", "桃花林", "狐仙洞", "五家染坊", "青林子", "南平关", "混元无极阵", "山阳道"]
        case .ninghaiCounty:
            return ["青牛坡", "青渡口", "小渔村", "沙子洲", "宁城山", "兰陵道", "锦绣林", "黄石岗"]
        case .shitangCounty:
            return ["平江原", "大粮仓", "十里堤林", "钱宁河", "喇叭口", "喇叭沟村", "九曲湾", "小君观", "东坡林", "天枢观", "黎阳道"]
        }
    }

    var experienceRange: ClosedRange<Int> {
        switch self {
        case .mulberryVillage:
            return 900...1_600
        case .ninghaiCounty:
            return 1_700...2_800
        case .shitangCounty:
            return 3_000...4_600
        }
    }

    var coinRange: ClosedRange<Int> {
        switch self {
        case .mulberryVillage:
            return 1...99
        case .ninghaiCounty:
            return 50...150
        case .shitangCounty:
            return 100...200
        }
    }

    var monsters: [MonsterDefinition] {
        MonsterDataStore.catalog.monsters(for: self)
    }
}

struct MonsterDefinition: Codable {
    let name: String
    let location: String?
    let levelMin: Int
    let levelMax: Int
    let health: Int
    let attack: Int
    let defense: Int
    let experience: Int
    let drops: [MonsterDropDefinition]
}

struct MonsterDropDefinition: Codable {
    let item: String
    let chance: Int
}

private struct MonsterCatalog {
    let mulberryVillage: [MonsterDefinition]
    let ninghaiCounty: [MonsterDefinition]
    let shitangCounty: [MonsterDefinition]

    func monsters(for map: HuntMap) -> [MonsterDefinition] {
        switch map {
        case .mulberryVillage:
            return mulberryVillage
        case .ninghaiCounty:
            return ninghaiCounty
        case .shitangCounty:
            return shitangCounty
        }
    }

    func levelRange(for map: HuntMap) -> ClosedRange<Int> {
        let monsters = monsters(for: map)
        let minimum = monsters.map(\.levelMin).min() ?? 1
        let maximum = monsters.map(\.levelMax).max() ?? minimum
        return minimum...maximum
    }
}

private struct MonsterEntryConfig: Codable {
    let name: String
    let location: String?
    let levelMin: Int
    let levelMax: Int
}

private struct MonsterCatalogConfig: Codable {
    let mulberryVillage: [MonsterEntryConfig]
    let ninghaiCounty: [MonsterEntryConfig]
    let shitangCounty: [MonsterEntryConfig]
}

private enum MonsterDataStore {
    static let catalog: MonsterCatalog = {
        let fallback = MonsterCatalogConfig(
            mulberryVillage: [
                MonsterEntryConfig(name: "豺", location: nil, levelMin: 1, levelMax: 1),
                MonsterEntryConfig(name: "野猪", location: nil, levelMin: 2, levelMax: 3)
            ],
            ninghaiCounty: [
                MonsterEntryConfig(name: "金花小妖", location: nil, levelMin: 11, levelMax: 12),
                MonsterEntryConfig(name: "螃蟹精", location: nil, levelMin: 15, levelMax: 17)
            ],
            shitangCounty: [
                MonsterEntryConfig(name: "蛤蟆精", location: "石门口", levelMin: 37, levelMax: 38),
                MonsterEntryConfig(name: "蜈蚣精", location: "金翅洞", levelMin: 32, levelMax: 36)
            ]
        )

        guard let url = Bundle.main.url(forResource: "monster-data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(MonsterCatalogConfig.self, from: data) else {
            return buildCatalog(from: fallback)
        }

        return buildCatalog(from: decoded)
    }()

    private static func buildCatalog(from config: MonsterCatalogConfig) -> MonsterCatalog {
        MonsterCatalog(
            mulberryVillage: config.mulberryVillage.map(buildMonster),
            ninghaiCounty: config.ninghaiCounty.map(buildMonster),
            shitangCounty: config.shitangCounty.map(buildMonster)
        )
    }

    private static func buildMonster(from entry: MonsterEntryConfig) -> MonsterDefinition {
        return MonsterDefinition(
            name: entry.name,
            location: entry.location,
            levelMin: entry.levelMin,
            levelMax: entry.levelMax,
            health: 0,
            attack: 0,
            defense: 0,
            experience: 0,
            drops: []
        )
    }

    static func defaultDrops(for level: Int) -> [MonsterDropDefinition] {
        var drops: [MonsterDropDefinition] = [
            MonsterDropDefinition(item: "none", chance: 44),
            MonsterDropDefinition(item: "essence", chance: 28),
            MonsterDropDefinition(item: "bruiseMedicine", chance: 14),
            MonsterDropDefinition(item: "revivalWater", chance: 8)
        ]

        switch level {
        case ..<10:
            drops.append(MonsterDropDefinition(item: "expPill1000", chance: 8))
            drops.append(MonsterDropDefinition(item: "noviceWeapon", chance: 3))
        case 10..<18:
            drops.append(MonsterDropDefinition(item: "expPill2000", chance: 10))
            drops.append(MonsterDropDefinition(item: "noviceHat", chance: 4))
        case 18..<26:
            drops.append(MonsterDropDefinition(item: "expPill3000", chance: 12))
            drops.append(MonsterDropDefinition(item: "noviceRobe", chance: 5))
        case 26..<34:
            drops.append(MonsterDropDefinition(item: "expPill4000", chance: 14))
            drops.append(MonsterDropDefinition(item: "novicePants", chance: 6))
        default:
            drops.append(MonsterDropDefinition(item: "expPill5000", chance: 16))
            drops.append(MonsterDropDefinition(item: "revivalPill", chance: 6))
            drops.append(MonsterDropDefinition(item: "noviceWeapon", chance: 7))
        }

        return drops
    }
}

private struct HuntSession {
    let map: HuntMap
    let endDate: Date
    var playerHealth: Int
    var revivalWaterCooldownTurns: Int
    var playerTurnCount: Int
    var pendingIncomingDamageReduction: Double
    var skillCooldowns: [ActiveSkill: Int]
    var monsterSkipNextAttack: Bool
    var monsterDefenseReductionHitsRemaining: Int
    var monsterDamageOverTimeRoundsRemaining: Int
    var monsterDamageOverTimeValue: Int
    var currentMonster: MonsterDefinition?
    var currentMonsterLevel: Int?
    var currentSubLocation: String?
    var currentMonsterHealth: Int
    var isPlayerTurn: Bool
    var nextTurnAt: Date?
}

struct PetState: Codable, Identifiable {
    let id: String
    let type: PetType
    var customName: String
    var strength: Int
    var physique: Int
    var spirit: Int
    var bone: Int
    var experience: Int
    var injury: Int
    var lastInteractionDate: Date
    var reviveAvailableAt: Date?
    var isDancing: Bool
    var danceNextTickAt: Date?
    var learnedSkills: [ActiveSkill]
    var equippedSkills: [ActiveSkill]
    var equippedItems: [EquipmentSlot: EquipmentItem]

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case customName
        case mood
        case satiety
        case hunger
        case energy
        case affection
        case strength
        case physique
        case spirit
        case bone
        case experience
        case injury
        case lastInteractionDate
        case reviveAvailableAt
        case isDancing
        case danceNextTickAt
        case learnedSkills
        case equippedSkills
        case equippedItems
        case workEndDate
        case workCooldownEndDate
        case pendingWorkReward
    }

    init(
        type: PetType,
        customName: String = "",
        strength: Int = 70,
        physique: Int = 80,
        spirit: Int = 80,
        bone: Int = 60,
        experience: Int = 0,
        injury: Int = 0,
        lastInteractionDate: Date = Date(),
        reviveAvailableAt: Date? = nil,
        isDancing: Bool = false,
        danceNextTickAt: Date? = nil,
        learnedSkills: [ActiveSkill] = [],
        equippedSkills: [ActiveSkill] = [],
        equippedItems: [EquipmentSlot: EquipmentItem] = [:]
    ) {
        self.id = type.id
        self.type = type
        self.customName = customName
        self.strength = strength
        self.physique = physique
        self.spirit = spirit
        self.bone = bone
        self.experience = experience
        self.injury = injury
        self.lastInteractionDate = lastInteractionDate
        self.reviveAvailableAt = reviveAvailableAt
        self.isDancing = isDancing
        self.danceNextTickAt = danceNextTickAt
        self.learnedSkills = learnedSkills
        self.equippedSkills = Array(equippedSkills.prefix(3))
        self.equippedItems = equippedItems
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(PetType.self, forKey: .type)
        customName = try container.decodeIfPresent(String.self, forKey: .customName) ?? ""
        lastInteractionDate = try container.decodeIfPresent(Date.self, forKey: .lastInteractionDate) ?? Date()
        reviveAvailableAt = try container.decodeIfPresent(Date.self, forKey: .reviveAvailableAt)
        isDancing = try container.decodeIfPresent(Bool.self, forKey: .isDancing) ?? false
        danceNextTickAt = try container.decodeIfPresent(Date.self, forKey: .danceNextTickAt)
        learnedSkills = try container.decodeIfPresent([ActiveSkill].self, forKey: .learnedSkills) ?? []
        equippedSkills = Array((try container.decodeIfPresent([ActiveSkill].self, forKey: .equippedSkills) ?? []).prefix(3))
        equippedItems = try container.decodeIfPresent([EquipmentSlot: EquipmentItem].self, forKey: .equippedItems) ?? [:]
        equippedItems = equippedItems.filter { $0.value.slot == $0.key }
        experience = try container.decodeIfPresent(Int.self, forKey: .experience) ?? 0
        injury = min(max(try container.decodeIfPresent(Int.self, forKey: .injury) ?? 0, 0), 100)

        let savedStrength = try container.decodeIfPresent(Int.self, forKey: .strength)
        let savedMood = try container.decodeIfPresent(Int.self, forKey: .mood)
        strength = savedStrength ?? savedMood ?? 70

        if let savedPhysique = try container.decodeIfPresent(Int.self, forKey: .physique) {
            physique = savedPhysique
        } else if let savedSatiety = try container.decodeIfPresent(Int.self, forKey: .satiety) {
            physique = savedSatiety
        } else if let savedHunger = try container.decodeIfPresent(Int.self, forKey: .hunger) {
            physique = 100 - savedHunger
        } else {
            physique = 80
        }

        let savedSpirit = try container.decodeIfPresent(Int.self, forKey: .spirit)
        let savedEnergy = try container.decodeIfPresent(Int.self, forKey: .energy)
        spirit = savedSpirit ?? savedEnergy ?? 80

        let savedBone = try container.decodeIfPresent(Int.self, forKey: .bone)
        let savedAffection = try container.decodeIfPresent(Int.self, forKey: .affection)
        bone = savedBone ?? savedAffection ?? 60
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(customName, forKey: .customName)
        try container.encode(strength, forKey: .strength)
        try container.encode(physique, forKey: .physique)
        try container.encode(spirit, forKey: .spirit)
        try container.encode(bone, forKey: .bone)
        try container.encode(experience, forKey: .experience)
        try container.encode(injury, forKey: .injury)
        try container.encode(lastInteractionDate, forKey: .lastInteractionDate)
        try container.encodeIfPresent(reviveAvailableAt, forKey: .reviveAvailableAt)
        try container.encode(isDancing, forKey: .isDancing)
        try container.encodeIfPresent(danceNextTickAt, forKey: .danceNextTickAt)
        try container.encode(learnedSkills, forKey: .learnedSkills)
        try container.encode(equippedSkills, forKey: .equippedSkills)
        try container.encode(equippedItems, forKey: .equippedItems)
    }
}

@MainActor
final class PetStore: ObservableObject {
    private static let defaultCoins = 21_025

    @Published private(set) var ownedPets: [PetState]
    @Published private(set) var coins: Int
    @Published private(set) var itemInventory: [InventoryItem: Int]
    @Published private(set) var equipmentInventory: [EquipmentItem: Int]
    @Published var selectedPetID: String? {
        didSet {
            guard oldValue != selectedPetID else { return }
            save()
        }
    }
    @Published var selectedHuntMap: HuntMap {
        didSet { save() }
    }
    @Published private(set) var lastActionSummary: String = ""
    @Published private(set) var battleLog: [String] = []
    @Published private(set) var currentHuntExperienceGained: Int = 0
    @Published private(set) var currentHuntCoinsGained: Int = 0

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var timer: Timer?
    private var huntSession: HuntSession?

    private enum Keys {
        static let ownedPets = "ownedPets"
        static let selectedPetID = "selectedPetID"
        static let coins = "coins"
        static let itemInventory = "itemInventory"
        static let equipmentInventory = "equipmentInventory"
        static let selectedHuntMap = "selectedHuntMap"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.ownedPets = Self.mergedPetsWithDefaults(Self.loadPets(from: defaults, decoder: decoder))
        self.selectedPetID = defaults.string(forKey: Keys.selectedPetID)
        self.coins = defaults.object(forKey: Keys.coins) as? Int ?? Self.defaultCoins
        self.itemInventory = Self.loadInventory(from: defaults, key: Keys.itemInventory, decoder: decoder)
        self.equipmentInventory = Self.loadEquipmentInventory(from: defaults, decoder: decoder)
        self.selectedHuntMap = HuntMap(rawValue: defaults.string(forKey: Keys.selectedHuntMap) ?? "") ?? .mulberryVillage

        if coins == 300 || coins == 514 {
            coins = Self.defaultCoins
        }

        if ownedPets.isEmpty == false, currentPet == nil {
            selectedPetID = ownedPets.first?.id
        }

        if itemInventory.isEmpty {
            itemInventory = [.essence: 20, .bruiseMedicine: 2]
        }

        clampAllPets()
        _ = refreshTimedStates(now: Date())
        save()
        startTimer()
    }

    deinit {
        timer?.invalidate()
    }

    var currentPet: PetState? {
        guard let selectedPetID else { return ownedPets.first }
        return ownedPets.first { $0.id == selectedPetID }
    }

    var canBuyMorePets: Bool {
        ownedPets.count < PetType.allCases.count
    }

    var goldBrickCount: Int {
        coins / 10_000
    }

    var goldCount: Int {
        (coins % 10_000) / 100
    }

    var silverCount: Int {
        coins % 100
    }

    var coinPrimaryDisplayText: String {
        if goldBrickCount > 0 {
            return "\(goldBrickCount)砖 \(goldCount)金 \(silverCount)银"
        }
        if goldCount > 0 {
            return "\(goldCount)金 \(silverCount)银"
        }
        return "\(silverCount)银"
    }

    var petName: String {
        guard let pet = currentPet else { return "还没有修仙者" }
        let trimmed = pet.customName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? pet.type.displayName : trimmed
    }

    var petIcon: String {
        currentPet?.type.icon ?? "🐾"
    }

    var strength: Int { currentPet?.strength ?? 0 }
    var physique: Int { currentPet?.physique ?? 0 }
    var spirit: Int { currentPet?.spirit ?? 0 }
    var bone: Int { currentPet?.bone ?? 0 }
    var injury: Int { currentPet?.injury ?? 0 }
    var currentPetCustomName: String { currentPet?.customName ?? "" }
    var currentEquippedItems: [EquipmentSlot: EquipmentItem] { currentPet?.equippedItems ?? [:] }

    var cultivationLevel: Int {
        guard let pet = currentPet else { return 1 }
        return level(for: pet.experience)
    }

    var currentExperience: Int {
        currentPet?.experience ?? 0
    }

    var levelDetailText: String {
        let level = cultivationLevel

        if level >= 100 {
            return "已达到最高等级 100"
        }

        let currentLevelBase = experienceThreshold(forLevel: level)
        let nextLevelNeed = experienceThreshold(forLevel: level + 1)
        let progress = currentExperience - currentLevelBase
        let needed = nextLevelNeed - currentLevelBase
        let remaining = max(nextLevelNeed - currentExperience, 0)

        return "本级进度：\(progress)/\(needed)\n距离下一级还需：\(remaining)"
    }

    var health: Int {
        100 + max(cultivationLevel - 1, 0) * 10 + equippedHealthBonus
    }

    var displayedHealth: Int {
        if let huntSession {
            return max(huntSession.playerHealth, 0)
        }
        return health
    }

    var attackPower: Int {
        guard currentPet?.type.showsAttackPower ?? true else { return 0 }
        return 15 + max(cultivationLevel - 1, 0) * 2 + equippedAttackBonus
    }

    var spellPower: Int {
        guard currentPet?.type.showsSpellPower ?? true else { return 0 }
        return 15 + max(cultivationLevel - 1, 0) * 2 + equippedSpellBonus
    }

    var defense: Int {
        5 + max(cultivationLevel - 1, 0) + equippedDefenseBonus
    }

    var equippedHealthBonus: Int {
        currentEquippedItems.values.reduce(0) { $0 + $1.bonusHealth }
    }

    var equippedAttackBonus: Int {
        currentEquippedItems.values.reduce(0) { $0 + $1.bonusAttack }
    }

    var equippedSpellBonus: Int {
        currentEquippedItems.values.reduce(0) { $0 + $1.bonusSpell }
    }

    var equippedDefenseBonus: Int {
        currentEquippedItems.values.reduce(0) { $0 + $1.bonusDefense }
    }

    var danceButtonTitle: String {
        guard let pet = currentPet else { return "跳舞" }
        guard pet.isDancing else { return "跳舞" }
        return "停止跳舞"
    }

    var isCurrentPetDead: Bool {
        guard let pet = currentPet else { return false }
        return isDead(pet)
    }

    var isHunting: Bool {
        huntSession != nil
    }

    var currentHuntSummaryText: String {
        "正在刷怪，本次已获得\(currentHuntExperienceGained)经验，\(formatCoins(currentHuntCoinsGained))。"
    }

    func canEnterHuntMap(_ map: HuntMap) -> Bool {
        cultivationLevel >= minimumLevelToEnter(map)
    }

    func minimumLevelToEnter(_ map: HuntMap) -> Int {
        map.levelRange.lowerBound
    }

    var revivalWaterCooldownTurns: Int {
        huntSession?.revivalWaterCooldownTurns ?? 0
    }

    var currentPassiveSkill: PassiveSkill? {
        currentPet?.type.passiveSkill
    }

    var currentLearnedSkills: [ActiveSkill] {
        currentPet?.learnedSkills ?? []
    }

    var currentEquippedSkills: [ActiveSkill] {
        currentPet?.equippedSkills ?? []
    }

    var deathDescription: String? {
        guard let pet = currentPet, let reviveAt = pet.reviveAvailableAt, reviveAt > Date() else { return nil }
        let seconds = max(Int(reviveAt.timeIntervalSince(Date())), 0)
        return "已死亡，\(seconds) 秒后自动复活"
    }

    var petSummary: String {
        guard let pet = currentPet else { return "去招募一位修仙者吧" }

        if isDead(pet) {
            return deathDescription ?? "已死亡"
        }

        if isHunting {
            return "正在刷怪"
        }

        if pet.isDancing {
            return "正在跳舞修炼，每 5 秒获得一次经验"
        }

        return ""
    }

    var ownedInventoryItems: [InventoryItem] {
        InventoryItem.allCases.filter { itemInventory[$0, default: 0] > 0 }
    }

    var ownedEquipmentItems: [EquipmentItem] {
        EquipmentItem.allCases.filter { equipmentInventory[$0, default: 0] > 0 }
    }

    func itemCount(for item: InventoryItem) -> Int {
        itemInventory[item, default: 0]
    }

    func equipmentCount(for item: EquipmentItem) -> Int {
        equipmentInventory[item, default: 0]
    }

    func equippedItem(for slot: EquipmentSlot) -> EquipmentItem? {
        currentEquippedItems[slot]
    }

    func canEquip(_ item: EquipmentItem) -> Bool {
        equipmentCount(for: item) > 0 && equippedItem(for: item.slot) != item
    }

    func canUnequip(_ slot: EquipmentSlot) -> Bool {
        equippedItem(for: slot) != nil
    }

    func canBuy(_ type: PetType) -> Bool {
        canBuyMorePets && coins >= type.purchasePrice && ownedPets.contains(where: { $0.type == type }) == false
    }

    func owns(_ type: PetType) -> Bool {
        ownedPets.contains(where: { $0.type == type })
    }

    func canBuy(_ item: InventoryItem) -> Bool {
        guard let price = item.purchasePrice else { return false }
        return coins >= price
    }

    func canUse(_ item: InventoryItem) -> Bool {
        guard itemCount(for: item) > 0, let pet = currentPet else { return false }

        if isDead(pet) {
            return item == .revivalPill
        }

        if item == .revivalWater {
            guard let session = huntSession else { return false }
            return session.revivalWaterCooldownTurns == 0 && session.playerHealth < playerBattleHealth(for: pet)
        }

        if let skill = item.skillBook {
            guard pet.type == skill.ownerType else { return false }
            guard cultivationLevel >= skill.requiredLevel else { return false }
            return pet.learnedSkills.contains(skill) == false
        }

        if item.injuryRecovery > 0 {
            return pet.injury > 0
        }

        if item.experienceGain > 0 {
            return level(for: pet.experience) < 100
        }

        return false
    }

    func canPerformAction() -> Bool {
        guard let pet = currentPet else { return false }
        return isDead(pet) == false && pet.isDancing == false && isHunting == false
    }

    func selectNextPet() {
        guard ownedPets.count > 1 else { return }

        let currentIndex = currentPetIndex ?? 0
        let nextIndex = (currentIndex + 1) % ownedPets.count
        selectedPetID = ownedPets[nextIndex].id
    }

    func selectPet(id: String) {
        guard ownedPets.contains(where: { $0.id == id }) else { return }
        guard selectedPetID != id else { return }
        selectedPetID = id
    }

    func renameCurrentPet(_ newName: String) {
        let trimmed = String(newName.prefix(12))
        updateCurrentPet { pet in
            pet.customName = trimmed
        }
        lastActionSummary = "已修改名称"
    }

    func buy(_ type: PetType) {
        guard canBuy(type) else { return }
        coins -= type.purchasePrice
        ownedPets.append(PetState(type: type))
        selectedPetID = type.id
        sortPets()
        lastActionSummary = "已招募 \(type.displayName)"
        save()
    }

    func buy(_ item: InventoryItem) {
        guard let price = item.purchasePrice, coins >= price else { return }
        coins -= price
        itemInventory[item, default: 0] += 1
        lastActionSummary = "购买成功：\(item.displayName)"
        save()
    }

    func clearMerchantNoticeIfNeeded() {
        guard lastActionSummary.hasPrefix("购买成功") || lastActionSummary.hasPrefix("购买了") else { return }
        lastActionSummary = ""
    }

    func use(_ item: InventoryItem) {
        guard canUse(item) else { return }
        guard let index = currentPetIndex else { return }

        itemInventory[item, default: 0] -= 1
        if itemInventory[item, default: 0] <= 0 {
            itemInventory[item] = nil
        }

        if item == .revivalPill {
            ownedPets[index].injury = 40
            ownedPets[index].reviveAvailableAt = nil
            ownedPets[index].isDancing = false
            ownedPets[index].danceNextTickAt = nil
            lastActionSummary = "使用续命丹，立即复活"
        } else if item == .revivalWater {
            guard var session = huntSession else { return }
            let maxHealth = playerBattleHealth(for: ownedPets[index])
            let recovery = max(1, maxHealth / 2)
            session.playerHealth = min(session.playerHealth + recovery, maxHealth)
            session.revivalWaterCooldownTurns = 5
            huntSession = session
            appendBattleLog("使用回生水，回复了\(recovery)点生命值")
            lastActionSummary = "使用回生水，回复 50% 生命值"
        } else if let skill = item.skillBook {
            if ownedPets[index].learnedSkills.contains(skill) == false {
                ownedPets[index].learnedSkills.append(skill)
            }
            if ownedPets[index].equippedSkills.contains(skill) == false,
               ownedPets[index].equippedSkills.count < 3 {
                ownedPets[index].equippedSkills.append(skill)
            }
            lastActionSummary = "学会了技能：\(skill.displayName)"
        } else if item.injuryRecovery > 0 {
            ownedPets[index].injury = max(ownedPets[index].injury - item.injuryRecovery, 0)
            lastActionSummary = "使用\(item.displayName)，受伤值 -\(item.injuryRecovery)"
        } else if item.experienceGain > 0 {
            let gained = gainExperience(item.experienceGain, for: index)
            lastActionSummary = "服用\(item.displayName)，获得 \(gained) 点经验"
        }

        save()
    }

    func equip(_ item: EquipmentItem) {
        guard let index = currentPetIndex, canEquip(item) else { return }

        if let previous = ownedPets[index].equippedItems[item.slot] {
            equipmentInventory[previous, default: 0] += 1
        }

        equipmentInventory[item, default: 0] -= 1
        if equipmentInventory[item, default: 0] <= 0 {
            equipmentInventory[item] = nil
        }

        ownedPets[index].equippedItems[item.slot] = item
        lastActionSummary = "已装备\(item.displayName)"
        save()
    }

    func unequip(_ slot: EquipmentSlot) {
        guard let index = currentPetIndex,
              let item = ownedPets[index].equippedItems.removeValue(forKey: slot) else { return }
        equipmentInventory[item, default: 0] += 1
        lastActionSummary = "已卸下\(item.displayName)"
        save()
    }

    func work() {
        guard canPerformAction(), let index = currentPetIndex else { return }

        let efficiency = efficiencyFactor(for: ownedPets[index].injury)
        let coinReward = scaledReward(Int.random(in: 500...2_000), efficiency: efficiency)
        let injuryGain = Int.random(in: 0...20)
        let drop = rollCommonDrop(level: level(for: ownedPets[index].experience), efficiency: efficiency, strongerLoot: true)

        coins += coinReward
        apply(drop: drop)
        applyInjury(injuryGain, to: index)

        var parts = ["打工获得 \(formatCoins(coinReward))"]
        if let drop {
            parts.append(drop.description)
        }
        if injuryGain > 0 {
            parts.append("受伤 +\(injuryGain)")
        }
        if isDead(ownedPets[index]) {
            parts.append("伤重死亡")
        }
        lastActionSummary = parts.joined(separator: "，")
        save()
    }

    func hunt() {
        guard canPerformAction(), let index = currentPetIndex else { return }
        guard canEnterHuntMap(selectedHuntMap) else {
            lastActionSummary = "\(selectedHuntMap.displayName)最低需\(minimumLevelToEnter(selectedHuntMap))级才能进入"
            save()
            return
        }
        stopHuntLoop()
        let fullHealth = playerBattleHealth(for: ownedPets[index])
        huntSession = HuntSession(
            map: selectedHuntMap,
            endDate: Date().addingTimeInterval(120),
            playerHealth: fullHealth,
            revivalWaterCooldownTurns: 0,
            playerTurnCount: 0,
            pendingIncomingDamageReduction: 0,
            skillCooldowns: [:],
            monsterSkipNextAttack: false,
            monsterDefenseReductionHitsRemaining: 0,
            monsterDamageOverTimeRoundsRemaining: 0,
            monsterDamageOverTimeValue: 0,
            currentMonster: nil,
            currentMonsterLevel: nil,
            currentSubLocation: nil,
            currentMonsterHealth: 0,
            isPlayerTurn: true,
            nextTurnAt: nil
        )
        currentHuntExperienceGained = 0
        currentHuntCoinsGained = 0
        battleLog = []
        appendBattleLog("开始前往\(selectedHuntMap.displayName)刷怪")
        startNextEncounter(at: Date())
        objectWillChange.send()
        save()
    }

    func endHunt() {
        guard isHunting else { return }
        stopHuntLoop()
        battleLog = []
        lastActionSummary = "已结束本次刷怪"
        save()
    }

    func scavenge() {
        guard canPerformAction(), let index = currentPetIndex else { return }

        let efficiency = efficiencyFactor(for: ownedPets[index].injury)
        let levelValue = level(for: ownedPets[index].experience)
        let experienceReward = scaledReward(Int.random(in: (200 + levelValue * 35)...(500 + levelValue * 55)), efficiency: efficiency)
        let gainedExperience = gainExperience(experienceReward, for: index)
        let drop = rollCommonDrop(level: levelValue, efficiency: efficiency * 0.6, strongerLoot: false)
        apply(drop: drop)

        var parts = ["拾荒获得 \(gainedExperience) 经验"]
        if let drop {
            parts.append(drop.description)
        } else {
            parts.append("没有找到额外道具")
        }
        lastActionSummary = parts.joined(separator: "，")
        save()
    }

    func toggleDance() {
        guard let index = currentPetIndex else { return }
        guard isDead(ownedPets[index]) == false else { return }
        guard isHunting == false else { return }

        if ownedPets[index].isDancing {
            ownedPets[index].isDancing = false
            ownedPets[index].danceNextTickAt = nil
            lastActionSummary = "停止跳舞"
        } else {
            ownedPets[index].isDancing = true
            ownedPets[index].danceNextTickAt = Date().addingTimeInterval(5)
            lastActionSummary = "开始跳舞，每 5 秒获得一次经验"
        }
        save()
    }

    func reset() {
        guard let index = currentPetIndex else { return }
        ownedPets[index].strength = 70
        ownedPets[index].physique = 80
        ownedPets[index].spirit = 80
        ownedPets[index].bone = 60
        ownedPets[index].experience = 0
        ownedPets[index].injury = 0
        ownedPets[index].reviveAvailableAt = nil
        ownedPets[index].isDancing = false
        ownedPets[index].danceNextTickAt = nil
        stopHuntLoop()
        huntSession = nil
        battleLog = []
        lastActionSummary = "已重置当前修仙者"
        save()
    }

    private var currentPetIndex: Int? {
        guard let selectedPetID else { return ownedPets.indices.first }
        return ownedPets.firstIndex { $0.id == selectedPetID }
    }

    private func updateCurrentPet(_ update: (inout PetState) -> Void) {
        guard let index = currentPetIndex else { return }
        update(&ownedPets[index])
        clampAllPets()
        save()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.advanceTime()
            }
        }

        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func advanceTime() {
        let now = Date()
        let shouldRefreshDeathCountdown = isCurrentPetDead
        let timedStatesChanged = refreshTimedStates(now: now)
        let huntStateChanged = advanceHuntIfNeeded(now: now)
        if timedStatesChanged || huntStateChanged || shouldRefreshDeathCountdown {
            objectWillChange.send()
            save()
        }
    }

    private func refreshTimedStates(now: Date) -> Bool {
        var didChange = false

        for index in ownedPets.indices {
            if let reviveAt = ownedPets[index].reviveAvailableAt, reviveAt <= now {
                ownedPets[index].reviveAvailableAt = nil
                ownedPets[index].injury = 60
                ownedPets[index].isDancing = false
                ownedPets[index].danceNextTickAt = nil
                didChange = true

                if ownedPets[index].id == selectedPetID {
                    lastActionSummary = "已自动复活，受伤值恢复到 60"
                }
            }

            guard ownedPets[index].isDancing,
                  ownedPets[index].reviveAvailableAt == nil,
                  var nextTick = ownedPets[index].danceNextTickAt else {
                continue
            }

            var gainedExperience = 0
            while nextTick <= now {
                let tickExperience = max(80, level(for: ownedPets[index].experience) * 30)
                gainedExperience += gainExperience(tickExperience, for: index)
                nextTick.addTimeInterval(5)
                didChange = true
            }

            ownedPets[index].danceNextTickAt = nextTick
            if gainedExperience > 0, ownedPets[index].id == selectedPetID {
                lastActionSummary = "跳舞获得 \(gainedExperience) 点经验"
            }
        }

        return didChange
    }

    private func stopHuntLoop() {
        huntSession = nil
        currentHuntExperienceGained = 0
        currentHuntCoinsGained = 0
    }

    private func advanceHuntIfNeeded(now: Date) -> Bool {
        guard let session = huntSession else { return false }

        if session.currentMonster == nil {
            if let nextTurnAt = session.nextTurnAt, now < nextTurnAt {
                return false
            }

            if now >= session.endDate {
                appendBattleLog("本次刷怪结束")
                lastActionSummary = "本次刷怪结束"
                huntSession = nil
                return true
            }

            startNextEncounter(at: now)
            return true
        }

        guard let nextTurnAt = session.nextTurnAt, now >= nextTurnAt else {
            return false
        }

        if session.isPlayerTurn {
            return processPlayerTurn(now: now)
        }

        return processMonsterTurn(now: now)
    }

    private func gainExperience(_ amount: Int, for index: Int) -> Int {
        let currentLevel = level(for: ownedPets[index].experience)
        guard currentLevel < 100 else { return 0 }

        let levelCapExperience = experienceThreshold(forLevel: 100)
        let newExperience = min(ownedPets[index].experience + max(amount, 0), levelCapExperience)
        let gained = newExperience - ownedPets[index].experience
        ownedPets[index].experience = newExperience
        return gained
    }

    private func battleEffectiveness(for pet: PetState) -> Double {
        guard pet.injury > 0 else { return 1 }
        return max(0, Double(100 - pet.injury) / 100.0)
    }

    private func effectiveBattleStat(_ base: Int, for pet: PetState) -> Int {
        max(Int((Double(base) * battleEffectiveness(for: pet)).rounded()), 1)
    }

    private func applyDamageVariance(to damage: Double) -> Int {
        let variance = Double.random(in: 0.9...1.1)
        return max(Int((damage * variance).rounded()), 1)
    }

    private func levelDamageMultiplier(attackerLevel: Int, defenderLevel: Int) -> Double {
        let levelDiff = Double(attackerLevel - defenderLevel)
        return 1.0 + 0.45 * tanh(levelDiff / 8.0)
    }

    private func defenseMitigationMultiplier(for defense: Int) -> Double {
        100.0 / (100.0 + Double(max(defense, 0)))
    }

    private func levelRewardFactor(playerLevel: Int, monsterLevel: Int) -> Double {
        let gap = abs(playerLevel - monsterLevel)
        guard gap > 5 else { return 1.0 }
        return max(0.2, 1.0 - (Double(gap - 5) * 0.08))
    }

    private func playerBattleHealth(for pet: PetState) -> Int {
        let baseHealth = 100 + max(level(for: pet.experience) - 1, 0) * 10
        return effectiveBattleStat(baseHealth, for: pet)
    }

    private func reducedCooldownTurns(from turns: Int) -> Int {
        max(turns - 1, 0)
    }

    private func autoUseRevivalWaterIfNeeded(session: inout HuntSession, pet: PetState, index: Int) {
        guard session.revivalWaterCooldownTurns == 0 else { return }
        guard itemInventory[.revivalWater, default: 0] > 0 else { return }

        let maxHealth = playerBattleHealth(for: pet)
        let threshold = max(1, Int(ceil(Double(maxHealth) * 0.2)))
        guard session.playerHealth < threshold else { return }

        let recovery = max(1, maxHealth / 2)
        session.playerHealth = min(session.playerHealth + recovery, maxHealth)
        session.revivalWaterCooldownTurns = 5
        itemInventory[.revivalWater, default: 0] -= 1
        if itemInventory[.revivalWater, default: 0] <= 0 {
            itemInventory[.revivalWater] = nil
        }
        appendBattleLog("\(petName)自动使用回生水，回复了\(recovery)点生命值")
    }

    private func startNextEncounter(at now: Date) {
        guard var session = huntSession else { return }
        let playerLevel = cultivationLevel
        let maxEncounterLevel = playerLevel + 5
        let availableMonsters = session.map.monsters.filter { $0.levelMin <= maxEncounterLevel }
        guard let monster = availableMonsters.randomElement() else {
            appendBattleLog("\(session.map.displayName)暂无适合当前等级的怪物")
            lastActionSummary = "暂无适合当前等级的怪物"
            huntSession = nil
            return
        }

        let monsterUpperBound = min(monster.levelMax, maxEncounterLevel)
        let monsterLevel = Int.random(in: monster.levelMin...monsterUpperBound)
        let subLocation = session.map.subLocations.randomElement() ?? session.map.displayName
        let runtimeMonster = monsterDefinition(from: monster, level: monsterLevel)
        session.currentMonster = runtimeMonster
        session.currentMonsterLevel = monsterLevel
        session.currentSubLocation = subLocation
        session.currentMonsterHealth = runtimeMonster.health
        session.isPlayerTurn = true
        session.nextTurnAt = now.addingTimeInterval(1)
        huntSession = session
        appendBattleLog("在\(subLocation)遇到了\(monster.name)（\(monsterLevel)级）")
    }

    private func processPlayerTurn(now: Date) -> Bool {
        guard var session = huntSession,
              let monster = session.currentMonster,
              let pet = currentPet else { return false }

        applyDamageOverTimeIfNeeded(session: &session, monster: monster)
        if session.currentMonsterHealth <= 0 {
            handleMonsterDefeat(monster: monster, at: now, session: session)
            return true
        }

        if processAutoSkillIfNeeded(now: now, session: &session, pet: pet, monster: monster) {
            return true
        }

        let basePower = effectiveBattleStat(attackPower, for: pet) + effectiveBattleStat(spellPower, for: pet)
        let monsterLevel = session.currentMonsterLevel ?? session.map.levelRange.lowerBound
        let monsterDefense = adjustedMonsterDefense(for: monsterLevel, session: session)
        let baseDamage = Double(basePower)
            * levelDamageMultiplier(attackerLevel: cultivationLevel, defenderLevel: monsterLevel)
            * defenseMitigationMultiplier(for: monsterDefense)
        let damage = applyDamageVariance(to: baseDamage)
        session.currentMonsterHealth -= damage
        appendBattleLog("\(petName)对\(monster.name)造成了\(damage)点伤害")
        applyPassiveProgress(for: pet.type, session: &session)

        if session.currentMonsterHealth <= 0 {
            session.revivalWaterCooldownTurns = reducedCooldownTurns(from: session.revivalWaterCooldownTurns)
            handleMonsterDefeat(monster: monster, at: now, session: session)
            return true
        }

        session.isPlayerTurn = false
        session.revivalWaterCooldownTurns = reducedCooldownTurns(from: session.revivalWaterCooldownTurns)
        session.nextTurnAt = now.addingTimeInterval(2)
        huntSession = session
        return true
    }

    private func processMonsterTurn(now: Date) -> Bool {
        guard var session = huntSession,
              let monster = session.currentMonster,
              let pet = currentPet,
              let index = currentPetIndex else { return false }

        if session.monsterSkipNextAttack {
            session.monsterSkipNextAttack = false
            appendBattleLog("\(monster.name)被镇压，当前回合无法攻击")
            autoUseRevivalWaterIfNeeded(session: &session, pet: pet, index: index)
            finishCombatRound(session: &session, now: now)
            huntSession = session
            return true
        }

        let effectiveDefense = effectiveBattleStat(defense, for: pet)
        let monsterLevel = session.currentMonsterLevel ?? session.map.levelRange.lowerBound
        var baseDamage = Double(monster.attack)
            * levelDamageMultiplier(attackerLevel: monsterLevel, defenderLevel: cultivationLevel)
            * defenseMitigationMultiplier(for: effectiveDefense)
        let damageReduction = session.pendingIncomingDamageReduction
        if damageReduction > 0 {
            baseDamage *= max(0, 1.0 - damageReduction)
            session.pendingIncomingDamageReduction = 0
        }
        let damage = applyDamageVariance(to: baseDamage)
        session.playerHealth -= damage
        if damageReduction > 0 {
            let reductionPercent = Int((damageReduction * 100).rounded())
            appendBattleLog("\(monster.name)对\(petName)造成了\(damage)点伤害（金刚护体减免\(reductionPercent)%）")
        } else {
            appendBattleLog("\(monster.name)对\(petName)造成了\(damage)点伤害")
        }

        if session.playerHealth <= 0 {
            appendBattleLog("\(petName)倒在了\(monster.name)手下。")
            ownedPets[index].injury = 100
            ownedPets[index].reviveAvailableAt = now.addingTimeInterval(60)
            ownedPets[index].isDancing = false
            ownedPets[index].danceNextTickAt = nil
            lastActionSummary = "\(petName)倒在了\(monster.name)手下。"
            huntSession = nil
            return true
        }

        autoUseRevivalWaterIfNeeded(session: &session, pet: pet, index: index)
        finishCombatRound(session: &session, now: now)
        huntSession = session
        return true
    }

    private func applyPassiveProgress(for type: PetType, session: inout HuntSession) {
        switch type {
        case .vajraGuardian:
            session.playerTurnCount += 1
            guard session.playerTurnCount >= 2 else { return }
            session.playerTurnCount = 0
            session.pendingIncomingDamageReduction = 0.3
        default:
            break
        }
    }

    private func finishCombatRound(session: inout HuntSession, now: Date) {
        session.isPlayerTurn = true
        session.revivalWaterCooldownTurns = reducedCooldownTurns(from: session.revivalWaterCooldownTurns)
        for skill in Array(session.skillCooldowns.keys) {
            session.skillCooldowns[skill] = reducedCooldownTurns(from: session.skillCooldowns[skill] ?? 0)
        }
        session.skillCooldowns = session.skillCooldowns.filter { $0.value > 0 }
        session.nextTurnAt = now.addingTimeInterval(2)
    }

    private func adjustedMonsterDefense(for monsterLevel: Int, session: HuntSession) -> Int {
        let baseDefense = monsterBaseDefense(for: monsterLevel)
        if session.monsterDefenseReductionHitsRemaining > 0 {
            return max(Int((Double(baseDefense) * 0.8).rounded()), 1)
        }
        return baseDefense
    }

    private func monsterDefinition(from template: MonsterDefinition, level: Int) -> MonsterDefinition {
        MonsterDefinition(
            name: template.name,
            location: template.location,
            levelMin: level,
            levelMax: level,
            health: monsterBaseHealth(for: level),
            attack: monsterBaseAttack(for: level),
            defense: monsterBaseDefense(for: level),
            experience: monsterBaseExperience(for: level),
            drops: monsterDrops(for: level)
        )
    }

    private func monsterBaseHealth(for level: Int) -> Int {
        80 + max(level, 1) * 10
    }

    private func monsterBaseAttack(for level: Int) -> Int {
        6 + max(level, 1)
    }

    private func monsterBaseDefense(for level: Int) -> Int {
        max(Int((Double(max(level, 1)) * 1.5).rounded()), 1)
    }

    private func monsterBaseExperience(for level: Int) -> Int {
        120 + max(level, 1) * 45
    }

    private func monsterDrops(for level: Int) -> [MonsterDropDefinition] {
        MonsterDataStore.defaultDrops(for: max(level, 1))
    }

    private func applyDamageOverTimeIfNeeded(session: inout HuntSession, monster: MonsterDefinition) {
        guard session.monsterDamageOverTimeRoundsRemaining > 0 else { return }
        let damage = max(session.monsterDamageOverTimeValue, 1)
        session.currentMonsterHealth -= damage
        session.monsterDamageOverTimeRoundsRemaining -= 1
        appendBattleLog("\(monster.name)持续流失\(damage)点生命值")
    }

    private func processAutoSkillIfNeeded(now: Date, session: inout HuntSession, pet: PetState, monster: MonsterDefinition) -> Bool {
        for skill in pet.equippedSkills {
            guard session.skillCooldowns[skill, default: 0] == 0 else { continue }
            guard cultivationLevel >= skill.requiredLevel else { continue }
            execute(skill: skill, now: now, session: &session, pet: pet, monster: monster)
            return true
        }
        return false
    }

    private func execute(skill: ActiveSkill, now: Date, session: inout HuntSession, pet: PetState, monster: MonsterDefinition) {
        let basePower = effectiveBattleStat(attackPower, for: pet) + effectiveBattleStat(spellPower, for: pet)
        let monsterLevel = session.currentMonsterLevel ?? session.map.levelRange.lowerBound
        let monsterDefense = adjustedMonsterDefense(for: monsterLevel, session: session)
        var multiplier = 1.0

        switch skill {
        case .vajraSuppression:
            session.monsterSkipNextAttack = true
            multiplier = 1.1
            appendBattleLog("\(petName)施放\(skill.displayName)，石敢当震退了\(monster.name)")
        case .vajraShock:
            session.monsterDefenseReductionHitsRemaining = 2
            multiplier = 1.1
            appendBattleLog("\(petName)施放\(skill.displayName)，\(monster.name)的防御降低20%")
        case .vajraSmite:
            session.monsterDamageOverTimeRoundsRemaining = 2
            session.monsterDamageOverTimeValue = max(effectiveBattleStat(attackPower, for: pet), 1)
            multiplier = 1.1
            appendBattleLog("\(petName)施放\(skill.displayName)，\(monster.name)将持续流失生命值")
        }

        let baseDamage = Double(basePower)
            * multiplier
            * levelDamageMultiplier(attackerLevel: cultivationLevel, defenderLevel: monsterLevel)
            * defenseMitigationMultiplier(for: monsterDefense)
        let damage = applyDamageVariance(to: baseDamage)
        session.currentMonsterHealth -= damage
        appendBattleLog("\(petName)对\(monster.name)造成了\(damage)点伤害")
        if session.monsterDefenseReductionHitsRemaining > 0 {
            session.monsterDefenseReductionHitsRemaining -= 1
        }
        applyPassiveProgress(for: pet.type, session: &session)
        session.skillCooldowns[skill] = skill.cooldownRounds

        if session.currentMonsterHealth <= 0 {
            session.revivalWaterCooldownTurns = reducedCooldownTurns(from: session.revivalWaterCooldownTurns)
            handleMonsterDefeat(monster: monster, at: now, session: session)
            return
        }

        session.isPlayerTurn = false
        session.revivalWaterCooldownTurns = reducedCooldownTurns(from: session.revivalWaterCooldownTurns)
        session.nextTurnAt = now.addingTimeInterval(2)
        huntSession = session
    }

    private func handleMonsterDefeat(monster: MonsterDefinition, at now: Date, session: HuntSession) {
        guard let index = currentPetIndex else {
            huntSession = nil
            return
        }

        let efficiency = efficiencyFactor(for: ownedPets[index].injury)
        let playerLevel = max(level(for: ownedPets[index].experience), 1)
        let monsterLevel = session.currentMonsterLevel ?? session.map.levelRange.lowerBound
        let rewardFactor = levelRewardFactor(playerLevel: playerLevel, monsterLevel: monsterLevel)
        let baseExperienceReward = Int(
            (
                Double(monster.experience) *
                (Double(monsterLevel) / Double(playerLevel)) *
                rewardFactor
            ).rounded()
        )
        let experienceReward = scaledReward(baseExperienceReward, efficiency: efficiency)
        let baseCoinReward = Int((Double(Int.random(in: session.map.coinRange)) * rewardFactor).rounded())
        let coinReward = scaledReward(baseCoinReward, efficiency: efficiency)
        let gainedExperience = gainExperience(experienceReward, for: index)
        coins += coinReward
        currentHuntExperienceGained += gainedExperience
        currentHuntCoinsGained += coinReward

        var dropTexts: [String] = []
        if let dropText = rollMonsterDrop(from: monster, efficiency: efficiency) {
            dropTexts.append(dropText)
        }
        if let skillBookText = rollSkillBookDrop(for: ownedPets[index], monsterLevel: monsterLevel, efficiency: efficiency) {
            dropTexts.append(skillBookText)
        }

        var defeatText = "\(petName)击败了\(monster.name)，掉落金钱\(formatCoins(coinReward))"
        if dropTexts.isEmpty == false {
            defeatText += "，掉落道具" + dropTexts.joined(separator: "、")
        }
        appendBattleLog(defeatText)
        lastActionSummary = "刷怪获得 \(gainedExperience) 经验，\(formatCoins(coinReward))"

        var updatedSession = session
        updatedSession.currentMonster = nil
        updatedSession.currentMonsterLevel = nil
        updatedSession.currentSubLocation = nil
        updatedSession.currentMonsterHealth = 0
        updatedSession.monsterSkipNextAttack = false
        updatedSession.monsterDefenseReductionHitsRemaining = 0
        updatedSession.monsterDamageOverTimeRoundsRemaining = 0
        updatedSession.monsterDamageOverTimeValue = 0
        updatedSession.nextTurnAt = now.addingTimeInterval(2)
        huntSession = updatedSession

        if now < updatedSession.endDate {
            objectWillChange.send()
            return
        } else {
            appendBattleLog("本次刷怪结束")
            huntSession = nil
        }
        objectWillChange.send()
    }

    private func applyInjury(_ amount: Int, to index: Int) {
        guard amount > 0 else { return }
        ownedPets[index].injury = min(ownedPets[index].injury + amount, 100)
        if ownedPets[index].injury >= 100 {
            ownedPets[index].injury = 100
            ownedPets[index].reviveAvailableAt = Date().addingTimeInterval(60)
            ownedPets[index].isDancing = false
            ownedPets[index].danceNextTickAt = nil
        }
    }

    private func apply(drop: ItemDrop?) {
        guard let drop else { return }
        switch drop {
        case let .item(item, amount):
            itemInventory[item, default: 0] += amount
        }
    }

    private func efficiencyFactor(for injury: Int) -> Double {
        max(0.15, 1.0 - (Double(injury) / 120.0))
    }

    private func scaledReward(_ base: Int, efficiency: Double) -> Int {
        max(1, Int((Double(base) * efficiency).rounded()))
    }

    private func rollCommonDrop(level: Int, efficiency: Double, strongerLoot: Bool) -> ItemDrop? {
        let chance = strongerLoot ? 0.82 * efficiency : 0.42 * efficiency
        guard Double.random(in: 0...1) <= chance else { return nil }

        let pool: [(Int, ItemDrop)] = [
            (24, .item(.bruiseMedicine, 1)),
            (9, .item(.revivalPill, 1)),
            (40, .item(.essence, Int.random(in: 5...25))),
            (27, .item(randomExperiencePill(for: level), 1))
        ]

        return weightedRandom(from: pool)
    }

    private func rollEquipmentDrop(efficiency: Double) -> EquipmentItem? {
        guard Double.random(in: 0...1) <= 0.5 else { return nil }
        return EquipmentItem.allCases.randomElement()
    }

    private func randomExperiencePill(for level: Int) -> InventoryItem {
        let available: [InventoryItem]
        switch level {
        case 1...10:
            available = [.expPill1000, .expPill2000, .expPill3000]
        case 11...20:
            available = [.expPill2000, .expPill3000, .expPill4000, .expPill5000]
        case 21...35:
            available = [.expPill3000, .expPill4000, .expPill5000, .expPill6000, .expPill7000, .expPill8000]
        default:
            available = InventoryItem.experiencePills
        }

        return available.randomElement() ?? .expPill1000
    }

    private func rollMonsterDrop(from monster: MonsterDefinition, efficiency: Double) -> String? {
        let weightedDrops = monster.drops.filter { $0.chance > 0 }
        guard weightedDrops.isEmpty == false else { return nil }

        let selected = weightedRandom(from: weightedDrops.map { ($0.chance, $0) })
        let adjustedDropChance = min(Double(selected.chance) * efficiency, Double(selected.chance))
        guard Double.random(in: 0..<100) < adjustedDropChance else { return nil }

        if selected.item == "none" {
            return nil
        }

        if let item = InventoryItem(rawValue: selected.item) {
            let amount: Int
            if item == .essence {
                amount = Int.random(in: 5...25)
            } else if item == .revivalWater {
                amount = Int.random(in: 1...5)
            } else {
                amount = 1
            }
            itemInventory[item, default: 0] += amount
            return amount > 1 ? "\(item.displayName)x\(amount)" : item.displayName
        }

        if let equipment = EquipmentItem(rawValue: selected.item) {
            equipmentInventory[equipment, default: 0] += 1
            return equipment.displayName
        }

        return nil
    }

    private func weightedRandom<T>(from entries: [(Int, T)]) -> T {
        let total = entries.reduce(0) { $0 + $1.0 }
        let roll = Int.random(in: 1...max(total, 1))
        var cursor = 0
        for (weight, value) in entries {
            cursor += weight
            if roll <= cursor {
                return value
            }
        }
        return entries[0].1
    }

    private func rollSkillBookDrop(for pet: PetState, monsterLevel: Int, efficiency: Double) -> String? {
        let missingSkills = pet.type.starterActiveSkills.filter {
            pet.learnedSkills.contains($0) == false && monsterLevel >= $0.requiredLevel
        }
        guard missingSkills.isEmpty == false else { return nil }
        guard Double.random(in: 0...1) <= 0.5 * efficiency else { return nil }
        guard let skill = missingSkills.randomElement(),
              let item = inventoryItem(for: skill) else { return nil }
        itemInventory[item, default: 0] += 1
        return item.displayName
    }

    private func inventoryItem(for skill: ActiveSkill) -> InventoryItem? {
        switch skill {
        case .vajraSuppression:
            return .vajraSuppressionBook
        case .vajraShock:
            return .vajraShockBook
        case .vajraSmite:
            return .vajraSmiteBook
        }
    }

    private func level(for experience: Int) -> Int {
        var level = 1
        while level < 100 && experience >= experienceThreshold(forLevel: level + 1) {
            level += 1
        }
        return level
    }

    private func experienceThreshold(forLevel level: Int) -> Int {
        guard level > 1 else { return 0 }
        var threshold = 0
        for currentLevel in 1..<(min(level, 101)) {
            threshold += 1_000 + (currentLevel - 1) * 500
        }
        return threshold
    }

    private func isDead(_ pet: PetState) -> Bool {
        guard let reviveAt = pet.reviveAvailableAt else { return false }
        return reviveAt > Date()
    }

    private func sortPets() {
        ownedPets.sort { lhs, rhs in
            guard let lhsIndex = PetType.allCases.firstIndex(of: lhs.type),
                  let rhsIndex = PetType.allCases.firstIndex(of: rhs.type) else {
                return lhs.type.displayName < rhs.type.displayName
            }
            return lhsIndex < rhsIndex
        }
    }

    private func clampAllPets() {
        for index in ownedPets.indices {
            ownedPets[index].strength = clamp(ownedPets[index].strength)
            ownedPets[index].physique = clamp(ownedPets[index].physique)
            ownedPets[index].spirit = clamp(ownedPets[index].spirit)
            ownedPets[index].bone = clamp(ownedPets[index].bone)
            ownedPets[index].injury = min(max(ownedPets[index].injury, 0), 100)
        }
    }

    private func clamp(_ value: Int) -> Int {
        min(max(value, 0), 100)
    }

    private func appendBattleLog(_ message: String) {
        battleLog = Array((battleLog + [message]).suffix(18))
    }

    private func formatCoins(_ amount: Int) -> String {
        let gold = amount / 100
        let silver = amount % 100
        if gold > 0 {
            return "\(gold)金\(silver)银"
        }
        return "\(silver)银"
    }

    private func save() {
        clampAllPets()
        coins = max(coins, 0)

        if let data = try? encoder.encode(ownedPets) {
            defaults.set(data, forKey: Keys.ownedPets)
        }

        if let data = try? encoder.encode(itemInventory) {
            defaults.set(data, forKey: Keys.itemInventory)
        }

        if let data = try? encoder.encode(equipmentInventory) {
            defaults.set(data, forKey: Keys.equipmentInventory)
        }

        defaults.set(selectedPetID, forKey: Keys.selectedPetID)
        defaults.set(coins, forKey: Keys.coins)
        defaults.set(selectedHuntMap.rawValue, forKey: Keys.selectedHuntMap)
    }

    private static func loadPets(from defaults: UserDefaults, decoder: JSONDecoder) -> [PetState] {
        guard let data = defaults.data(forKey: Keys.ownedPets),
              let pets = try? decoder.decode([PetState].self, from: data) else {
            return []
        }
        return pets
    }

    private static func mergedPetsWithDefaults(_ pets: [PetState]) -> [PetState] {
        var petsByType = Dictionary(uniqueKeysWithValues: pets.map { ($0.type, $0) })

        for type in PetType.allCases where petsByType[type] == nil {
            petsByType[type] = PetState(type: type)
        }

        return PetType.allCases.compactMap { petsByType[$0] }
    }

    private static func loadInventory(from defaults: UserDefaults, key: String, decoder: JSONDecoder) -> [InventoryItem: Int] {
        guard let data = defaults.data(forKey: key),
              let inventory = try? decoder.decode([InventoryItem: Int].self, from: data) else {
            return [:]
        }
        return inventory
    }

    private static func loadEquipmentInventory(from defaults: UserDefaults, decoder: JSONDecoder) -> [EquipmentItem: Int] {
        guard let data = defaults.data(forKey: Keys.equipmentInventory),
              let inventory = try? decoder.decode([EquipmentItem: Int].self, from: data) else {
            return [:]
        }
        return inventory
    }
}

private enum ItemDrop {
    case item(InventoryItem, Int)

    var description: String {
        switch self {
        case let .item(item, amount):
            return "获得 \(item.displayName)x\(amount)"
        }
    }

    var shortDescription: String {
        switch self {
        case let .item(item, amount):
            return amount > 1 ? "\(item.displayName)x\(amount)" : item.displayName
        }
    }
}
