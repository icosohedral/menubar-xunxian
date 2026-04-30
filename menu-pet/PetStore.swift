//
//  PetStore.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import Combine
import Foundation

enum SpiritGrade: String, CaseIterable, Codable, Identifiable {
    case essence

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .essence:
            return "妖怪精魄"
        }
    }

    var icon: String {
        switch self {
        case .essence:
            return "✨"
        }
    }

    var satietyRecovery: Int {
        switch self {
        case .essence:
            return 24
        }
    }

    var affectionBonus: Int {
        switch self {
        case .essence:
            return 6
        }
    }

    var purchasePrice: Int {
        switch self {
        case .essence:
            return 2
        }
    }
}

struct PetState: Codable, Identifiable {
    let id: String
    let type: PetType
    var customName: String
    var mood: Int
    var satiety: Int
    var energy: Int
    var affection: Int
    var lastInteractionDate: Date
    var workEndDate: Date?
    var workCooldownEndDate: Date?
    var pendingWorkReward: Int

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case customName
        case mood
        case satiety
        case hunger
        case energy
        case affection
        case lastInteractionDate
        case workEndDate
        case workCooldownEndDate
        case pendingWorkReward
    }

    init(
        type: PetType,
        customName: String = "",
        mood: Int = 70,
        satiety: Int = 80,
        energy: Int = 80,
        affection: Int = 60,
        lastInteractionDate: Date = Date(),
        workEndDate: Date? = nil,
        workCooldownEndDate: Date? = nil,
        pendingWorkReward: Int = 0
    ) {
        self.id = type.id
        self.type = type
        self.customName = customName
        self.mood = mood
        self.satiety = satiety
        self.energy = energy
        self.affection = affection
        self.lastInteractionDate = lastInteractionDate
        self.workEndDate = workEndDate
        self.workCooldownEndDate = workCooldownEndDate
        self.pendingWorkReward = pendingWorkReward
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(PetType.self, forKey: .type)
        customName = try container.decodeIfPresent(String.self, forKey: .customName) ?? ""
        mood = try container.decodeIfPresent(Int.self, forKey: .mood) ?? 70
        energy = try container.decodeIfPresent(Int.self, forKey: .energy) ?? 80
        affection = try container.decodeIfPresent(Int.self, forKey: .affection) ?? 60
        lastInteractionDate = try container.decodeIfPresent(Date.self, forKey: .lastInteractionDate) ?? Date()
        workEndDate = try container.decodeIfPresent(Date.self, forKey: .workEndDate)
        workCooldownEndDate = try container.decodeIfPresent(Date.self, forKey: .workCooldownEndDate)
        pendingWorkReward = try container.decodeIfPresent(Int.self, forKey: .pendingWorkReward) ?? 0

        if let savedSatiety = try container.decodeIfPresent(Int.self, forKey: .satiety) {
            satiety = savedSatiety
        } else if let savedHunger = try container.decodeIfPresent(Int.self, forKey: .hunger) {
            satiety = 100 - savedHunger
        } else {
            satiety = 80
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(customName, forKey: .customName)
        try container.encode(mood, forKey: .mood)
        try container.encode(satiety, forKey: .satiety)
        try container.encode(energy, forKey: .energy)
        try container.encode(affection, forKey: .affection)
        try container.encode(lastInteractionDate, forKey: .lastInteractionDate)
        try container.encodeIfPresent(workEndDate, forKey: .workEndDate)
        try container.encodeIfPresent(workCooldownEndDate, forKey: .workCooldownEndDate)
        try container.encode(pendingWorkReward, forKey: .pendingWorkReward)
    }
}

@MainActor
final class PetStore: ObservableObject {
    @Published private(set) var ownedPets: [PetState]
    @Published private(set) var coins: Int
    @Published private(set) var spiritInventory: [SpiritGrade: Int]
    @Published var selectedPetID: String? {
        didSet {
            guard oldValue != selectedPetID else { return }
            refreshWorkStates()
            save()
        }
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var timer: Timer?

    private enum Keys {
        static let ownedPets = "ownedPets"
        static let selectedPetID = "selectedPetID"
        static let coins = "coins"
        static let spiritInventory = "spiritInventory"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.ownedPets = Self.loadPets(from: defaults, decoder: decoder)
        self.selectedPetID = defaults.string(forKey: Keys.selectedPetID)
        self.coins = defaults.object(forKey: Keys.coins) as? Int ?? 300
        self.spiritInventory = Self.loadSpiritInventory(from: defaults, decoder: decoder)

        if spiritInventory.isEmpty {
            spiritInventory = [
                .essence: 100
            ]
        }

        if currentPet == nil {
            selectedPetID = ownedPets.first?.id
        }

        clampAllPets()
        refreshWorkStates()
        coins = max(coins, 0)
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

    var availablePets: [PetType] {
        PetType.allCases.filter { type in
            ownedPets.contains(where: { $0.type == type }) == false
        }
    }

    var canBuyMorePets: Bool {
        ownedPets.count < 3
    }

    var currentPetSalePrice: Int {
        currentPet?.type.salePrice ?? 0
    }

    var petName: String {
        guard let pet = currentPet else {
            return "还没有宠物"
        }

        return pet.customName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? pet.type.displayName : pet.customName
    }

    var petSubtitle: String {
        guard let pet = currentPet else {
            return "去购买一只新宠物吧"
        }

        if pet.customName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return pet.type.speciesName
        }

        return "\(pet.type.displayName) · \(pet.type.speciesName)"
    }

    var petIcon: String {
        guard let pet = currentPet else {
            return "🐾"
        }

        return pet.type.icon
    }

    var petMoodEmoji: String {
        guard let pet = currentPet else {
            return "🙂"
        }

        return pet.type.moodEmoji(mood: pet.mood, satiety: pet.satiety, energy: pet.energy)
    }

    var petSummary: String {
        guard let pet = currentPet else {
            return "当前没有宠物"
        }

        if isWorking(pet) {
            return "正在打工，结束后自动结算金币"
        }

        if let cooldownSeconds = cooldownRemainingSeconds(for: pet), cooldownSeconds > 0 {
            return "打工冷却中，还需 \(cooldownSeconds / 60) 分 \(cooldownSeconds % 60) 秒"
        }

        switch pet.mood {
        case 80...100:
            return "状态很好"
        case 60..<80:
            return "心情不错"
        case 40..<60:
            return "一切正常"
        case 20..<40:
            return "需要陪伴"
        default:
            return "有点不开心"
        }
    }

    var mood: Int {
        currentPet?.mood ?? 0
    }

    var satiety: Int {
        currentPet?.satiety ?? 0
    }

    var energy: Int {
        currentPet?.energy ?? 0
    }

    var affection: Int {
        currentPet?.affection ?? 0
    }

    var currentPetCustomName: String {
        currentPet?.customName ?? ""
    }

    var workButtonTitle: String {
        guard let pet = currentPet else {
            return "打工"
        }

        if isWorking(pet) {
            let seconds = workRemainingSeconds(for: pet)
            return "打工中 \(seconds / 60):\(String(format: "%02d", seconds % 60))"
        }

        if let seconds = cooldownRemainingSeconds(for: pet), seconds > 0 {
            return "冷却中 \(seconds / 60):\(String(format: "%02d", seconds % 60))"
        }

        return "打工"
    }

    var isCurrentPetWorking: Bool {
        guard let pet = currentPet else { return false }
        return isWorking(pet)
    }

    var workDescription: String {
        guard let pet = currentPet else {
            return "购买宠物后才能开始打工"
        }

        if isWorking(pet) {
            return "打工总时长 5 分钟"
        }

        if cooldownRemainingSeconds(for: pet) != nil {
            return "打工冷却时间 5 分钟"
        }

        return "工作 5 分钟后获得 \(pet.type.workReward) 金币"
    }

    func spiritCount(for grade: SpiritGrade) -> Int {
        spiritInventory[grade, default: 0]
    }

    func canBuy(_ type: PetType) -> Bool {
        canBuyMorePets && coins >= type.purchasePrice && ownedPets.contains(where: { $0.type == type }) == false
    }

    func owns(_ type: PetType) -> Bool {
        ownedPets.contains(where: { $0.type == type })
    }

    func canBuySpirit(_ grade: SpiritGrade) -> Bool {
        coins >= grade.purchasePrice
    }

    func canFeed(_ grade: SpiritGrade) -> Bool {
        currentPet != nil && spiritCount(for: grade) > 0
    }

    func canStartWork() -> Bool {
        guard let pet = currentPet else { return false }
        return isWorking(pet) == false && cooldownRemainingSeconds(for: pet) == nil
    }

    func renameCurrentPet(_ newName: String) {
        let trimmed = String(newName.prefix(12))
        updateCurrentPet { pet in
            pet.customName = trimmed
            pet.lastInteractionDate = Date()
        }
    }

    func buy(_ type: PetType) {
        guard canBuy(type) else { return }

        coins -= type.purchasePrice
        ownedPets.append(PetState(type: type))
        selectedPetID = type.id
        sortPets()
        save()
    }

    func buySpirit(_ grade: SpiritGrade) {
        guard canBuySpirit(grade) else { return }
        coins -= grade.purchasePrice
        spiritInventory[grade, default: 0] += 1
        save()
    }

    func sellCurrentPet() {
        guard let selectedPetID else { return }
        sellPet(withID: selectedPetID)
    }

    func sellPet(of type: PetType) {
        guard let pet = ownedPets.first(where: { $0.type == type }) else { return }
        sellPet(withID: pet.id)
    }

    private func sellPet(withID petID: String) {
        guard let pet = ownedPets.first(where: { $0.id == petID }) else { return }

        coins += pet.type.salePrice
        ownedPets.removeAll { $0.id == petID }

        if ownedPets.isEmpty {
            self.selectedPetID = nil
        } else if selectedPetID == petID {
            self.selectedPetID = ownedPets.first?.id
        }

        save()
    }

    func work() {
        refreshWorkStates()
        guard canStartWork() else { return }

        updateCurrentPet { pet in
            let now = Date()
            pet.workEndDate = now.addingTimeInterval(5 * 60)
            pet.workCooldownEndDate = now.addingTimeInterval(10 * 60)
            pet.pendingWorkReward = pet.type.workReward
        }
    }

    func feed(_ grade: SpiritGrade) {
        guard spiritCount(for: grade) > 0 else { return }

        updateCurrentPet { pet in
            spiritInventory[grade, default: 0] -= 1
            pet.satiety = clamp(pet.satiety + grade.satietyRecovery)
            pet.affection = clamp(pet.affection + grade.affectionBonus)
            pet.lastInteractionDate = Date()
        }
    }

    func play() {
        updateCurrentPet { pet in
            pet.mood = clamp(pet.mood + 12)
            pet.energy = clamp(pet.energy - 10)
            pet.satiety = clamp(pet.satiety - 4)
            pet.lastInteractionDate = Date()
        }
    }

    func sleep() {
        updateCurrentPet { pet in
            pet.energy = clamp(pet.energy + 25)
            pet.mood = clamp(pet.mood + 4)
            pet.satiety = clamp(pet.satiety - 2)
            pet.lastInteractionDate = Date()
        }
    }

    func pet() {
        updateCurrentPet { pet in
            pet.mood = clamp(pet.mood + 8)
            pet.affection = clamp(pet.affection + 10)
            pet.satiety = clamp(pet.satiety - 1)
            pet.lastInteractionDate = Date()
        }
    }

    func reset() {
        updateCurrentPet { pet in
            pet.mood = 70
            pet.satiety = 80
            pet.energy = 80
            pet.affection = 60
            pet.workEndDate = nil
            pet.workCooldownEndDate = nil
            pet.pendingWorkReward = 0
        }
    }

    private func updateCurrentPet(_ update: (inout PetState) -> Void) {
        refreshWorkStates()

        guard let selectedPetID else { return }
        guard let index = ownedPets.firstIndex(where: { $0.id == selectedPetID }) else { return }

        update(&ownedPets[index])
        clampPet(at: index)
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
        refreshWorkStates()

        let currentSecond = Calendar.current.component(.second, from: Date())
        guard currentSecond == 0 else {
            save()
            return
        }

        for index in ownedPets.indices {
            ownedPets[index].satiety = clamp(ownedPets[index].satiety - 2)
            ownedPets[index].energy = clamp(ownedPets[index].energy - 1)

            if ownedPets[index].satiety < 30 || ownedPets[index].energy < 30 {
                ownedPets[index].mood = clamp(ownedPets[index].mood - 3)
            }

            if Date().timeIntervalSince(ownedPets[index].lastInteractionDate) >= 10 * 60 {
                ownedPets[index].affection = clamp(ownedPets[index].affection - 2)
            }

            autoFeedPetIfNeeded(at: index)
        }

        save()
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
            clampPet(at: index)
        }
    }

    private func clampPet(at index: Int) {
        ownedPets[index].mood = clamp(ownedPets[index].mood)
        ownedPets[index].satiety = clamp(ownedPets[index].satiety)
        ownedPets[index].energy = clamp(ownedPets[index].energy)
        ownedPets[index].affection = clamp(ownedPets[index].affection)
    }

    private func clamp(_ value: Int) -> Int {
        min(max(value, 0), 100)
    }

    private func refreshWorkStates() {
        let now = Date()

        for index in ownedPets.indices {
            if let workEndDate = ownedPets[index].workEndDate, workEndDate <= now {
                coins += ownedPets[index].pendingWorkReward
                ownedPets[index].pendingWorkReward = 0
                ownedPets[index].workEndDate = nil
                ownedPets[index].energy = clamp(ownedPets[index].energy - 18)
                ownedPets[index].satiety = clamp(ownedPets[index].satiety - 12)
                ownedPets[index].mood = clamp(ownedPets[index].mood - 6)
                ownedPets[index].affection = clamp(ownedPets[index].affection - 4)
            }

            if let cooldownEndDate = ownedPets[index].workCooldownEndDate, cooldownEndDate <= now {
                ownedPets[index].workCooldownEndDate = nil
            }

            autoFeedPetIfNeeded(at: index)
        }
    }

    private func autoFeedPetIfNeeded(at index: Int) {
        guard ownedPets[index].satiety < 20 else { return }

        for grade in SpiritGrade.allCases {
            if spiritInventory[grade, default: 0] > 0 {
                spiritInventory[grade, default: 0] -= 1
                ownedPets[index].satiety = clamp(ownedPets[index].satiety + grade.satietyRecovery)
                ownedPets[index].affection = clamp(ownedPets[index].affection + grade.affectionBonus)
                break
            }
        }
    }

    private func isWorking(_ pet: PetState) -> Bool {
        guard let workEndDate = pet.workEndDate else { return false }
        return workEndDate > Date()
    }

    private func cooldownRemainingSeconds(for pet: PetState) -> Int? {
        guard let cooldownEndDate = pet.workCooldownEndDate else { return nil }
        let seconds = Int(cooldownEndDate.timeIntervalSince(Date()))
        return seconds > 0 ? seconds : nil
    }

    private func workRemainingSeconds(for pet: PetState) -> Int {
        guard let workEndDate = pet.workEndDate else { return 0 }
        return max(Int(workEndDate.timeIntervalSince(Date())), 0)
    }

    private func save() {
        clampAllPets()
        coins = max(coins, 0)

        if let data = try? encoder.encode(ownedPets) {
            defaults.set(data, forKey: Keys.ownedPets)
        }

        if let data = try? encoder.encode(spiritInventory) {
            defaults.set(data, forKey: Keys.spiritInventory)
        }

        defaults.set(selectedPetID, forKey: Keys.selectedPetID)
        defaults.set(coins, forKey: Keys.coins)
    }

    private static func loadPets(from defaults: UserDefaults, decoder: JSONDecoder) -> [PetState] {
        guard let data = defaults.data(forKey: Keys.ownedPets),
              let pets = try? decoder.decode([PetState].self, from: data) else {
            return []
        }

        return pets
    }

    private static func loadSpiritInventory(from defaults: UserDefaults, decoder: JSONDecoder) -> [SpiritGrade: Int] {
        guard let data = defaults.data(forKey: Keys.spiritInventory),
              let inventory = try? decoder.decode([SpiritGrade: Int].self, from: data) else {
            return [:]
        }

        return inventory
    }
}
