//
//  ContentView.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import SwiftUI

private let sidePanelHeight: CGFloat = 320
private let portraitPanelWidth: CGFloat = 200
private let topPanelSpacing: CGFloat = 14
private let appPanelWidth: CGFloat = 340
private let contentHorizontalPadding: CGFloat = 16
private let functionPanelWidth: CGFloat = appPanelWidth - (contentHorizontalPadding * 2) - portraitPanelWidth - topPanelSpacing

struct ContentView: View {
    @EnvironmentObject private var petStore: PetStore
    @State private var currentPage: Page = .care

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if currentPage == .care {
                CarePanel(
                    petStore: petStore,
                    openSkill: { currentPage = .skills },
                    openWarehouse: { currentPage = .warehouse },
                    openMerchant: { currentPage = .merchant }
                )
            } else if currentPage == .skills {
                SkillPage(
                    petStore: petStore,
                    closeSkill: { currentPage = .care }
                )
            } else if currentPage == .warehouse {
                WarehousePage(
                    petStore: petStore,
                    closeWarehouse: { currentPage = .care }
                )
            } else {
                MerchantPage(
                    petStore: petStore,
                    closeMerchant: { currentPage = .care }
                )
            }
        }
        .padding(16)
        .frame(width: appPanelWidth)
    }

    private var header: some View {
        HStack {
            Text("寻仙宠物")
                .font(.headline)
            Spacer()
            Menu {
                ForEach(petStore.ownedPets) { pet in
                    Button(action: {
                        petStore.selectPet(id: pet.id)
                    }) {
                        HStack {
                            Text(pet.type.displayName)
                            if pet.id == petStore.currentPet?.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 14, height: 14)
                    .opacity(petStore.ownedPets.count > 1 ? 1 : 0.35)
            }
            .disabled(petStore.ownedPets.count <= 1)
            .accessibilityLabel("切换角色")
            .help(petStore.ownedPets.count > 1 ? "选择要切换的角色" : "至少拥有两位角色才能切换")
            CurrencyDisplay(
                goldBricks: petStore.goldBrickCount,
                gold: petStore.goldCount,
                silver: petStore.silverCount,
                accessibilityLabel: petStore.coinPrimaryDisplayText
            )
        }
    }
}

private struct CurrencyDisplay: View {
    let goldBricks: Int
    let gold: Int
    let silver: Int
    let accessibilityLabel: String

    var body: some View {
        HStack(spacing: 5) {
            CurrencyValue(iconName: "GoldBrickIcon", value: goldBricks)
            CurrencyValue(iconName: "GoldIcon", value: gold)
            CurrencyValue(iconName: "SilverIcon", value: silver)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }
}

private struct CurrencyValue: View {
    let iconName: String
    let value: Int

    var body: some View {
        HStack(spacing: 2) {
            Text("\(value)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Image(iconName)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 14, height: 14)
        }
    }
}

private enum Page {
    case care
    case skills
    case warehouse
    case merchant
}

private struct CarePanel: View {
    @ObservedObject var petStore: PetStore
    let openSkill: () -> Void
    let openWarehouse: () -> Void
    let openMerchant: () -> Void
    @State private var isRenamingPet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: topPanelSpacing) {
                CultivatorPortraitCard(
                    icon: petStore.petIcon,
                    petType: petStore.currentPet?.type,
                    portraitAssetName: petStore.currentPet?.type.portraitAssetName,
                    name: petStore.petName,
                    level: petStore.cultivationLevel,
                    levelDetailText: petStore.levelDetailText,
                    health: petStore.displayedHealth,
                    isHunting: petStore.isHunting,
                    attackPower: petStore.attackPower,
                    spellPower: petStore.spellPower,
                    defense: petStore.defense,
                    injury: petStore.injury,
                    isRenamable: petStore.ownedPets.isEmpty == false,
                    renameAction: {
                        isRenamingPet.toggle()
                    }
                )

                FunctionPanel(
                    hasCultivator: petStore.ownedPets.isEmpty == false,
                    openSkill: openSkill,
                    openWarehouse: openWarehouse,
                    openMerchant: openMerchant
                )
            }

            if petStore.ownedPets.isEmpty == false {
                if isRenamingPet {
                    TextField(
                        "给当前修仙者起名字",
                        text: Binding(
                            get: { petStore.currentPetCustomName },
                            set: { petStore.renameCurrentPet($0) }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                }
            }

            InteractionPanel(petStore: petStore)
        }
    }
}

private struct CultivatorPortraitCard: View {
    let icon: String
    let petType: PetType?
    let portraitAssetName: String?
    let name: String
    let level: Int
    let levelDetailText: String
    let health: Int
    let isHunting: Bool
    let attackPower: Int
    let spellPower: Int
    let defense: Int
    let injury: Int
    let isRenamable: Bool
    let renameAction: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.quaternary.opacity(0.24))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.separator.opacity(0.5), lineWidth: 1)
                )

            VStack(spacing: 10) {
                HStack(alignment: .top, spacing: 8) {
                    Button(action: renameAction) {
                        Text(name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .buttonStyle(.plain)
                    .disabled(isRenamable == false)

                    Spacer(minLength: 0)

                    Text("Lv.\(level)")
                        .font(.headline.monospacedDigit())
                        .help(levelDetailText)
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)

                Spacer()
                if let portraitAssetName {
                    Image(portraitAssetName)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 10)
                } else {
                    Text(icon)
                        .font(.system(size: 92))
                }
                Spacer()

                VStack(alignment: .leading, spacing: 6) {
                    DetailStatRow(title: isHunting ? "生命值（战斗中）" : "生命值", value: health)
                    if petType?.showsAttackPower ?? true {
                        DetailStatRow(title: "攻击力", value: attackPower)
                    }
                    if petType?.showsSpellPower ?? true {
                        DetailStatRow(title: "法术效果", value: spellPower)
                    }
                    DetailStatRow(title: "防御力", value: defense)
                    DetailStatRow(title: "受伤值", value: injury)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: portraitPanelWidth)
        .frame(minHeight: sidePanelHeight, maxHeight: sidePanelHeight)
    }
}

private struct FunctionPanel: View {
    let hasCultivator: Bool
    let openSkill: () -> Void
    let openWarehouse: () -> Void
    let openMerchant: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Button(action: openMerchant) {
                Image("StoreIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .padding(.vertical, 2)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("商城")

            Button(action: openWarehouse) {
                Image("BackpackIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .padding(.vertical, 2)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("背包")
            .disabled(hasCultivator == false)

            Button(action: openSkill) {
                Image("SkillIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(.vertical, 2)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("技能")
            .disabled(hasCultivator == false)

            Spacer()
        }
        .padding(12)
        .frame(width: functionPanelWidth, height: sidePanelHeight)
        .background(.quaternary.opacity(0.24), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.separator.opacity(0.5), lineWidth: 1)
        )
    }
}

private struct SkillPage: View {
    @ObservedObject var petStore: PetStore
    let closeSkill: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button("返回", action: closeSkill)
                    .buttonStyle(.bordered)

                Spacer()

                Text("技能")
                    .font(.headline)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 1)
            }

            if let pet = petStore.currentPet {
                VStack(alignment: .leading, spacing: 10) {
                    Text("被动技能")
                        .font(.subheadline)

                    if let passiveSkill = pet.type.passiveSkill {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(passiveSkill.name)
                                .font(.headline)
                            Text(passiveSkill.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("当前职业暂未配置被动技能。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("主动技能")
                        .font(.subheadline)

                    ForEach(1...3, id: \.self) { slot in
                        let equippedSkill = petStore.currentEquippedSkills.indices.contains(slot - 1)
                        ? petStore.currentEquippedSkills[slot - 1]
                        : nil
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(equippedSkill?.displayName ?? "技能槽位 \(slot)")
                                    .font(.subheadline)
                                Text(equippedSkill?.description ?? "未装备")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                            Text(equippedSkill == nil ? "未装备" : "已装备")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(.quaternary.opacity(0.28), in: RoundedRectangle(cornerRadius: 12))
                    }

                    if petStore.currentLearnedSkills.isEmpty == false {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("已学技能书")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(petStore.currentLearnedSkills.map(\.displayName).joined(separator: "、"))
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

private struct InteractionPanel: View {
    @ObservedObject var petStore: PetStore
    @State private var isChoosingHuntMap = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if petStore.currentPet != nil {
                if petStore.isHunting {
                    HStack(alignment: .center, spacing: 12) {
                        Text(petStore.currentHuntSummaryText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button("结束战斗") {
                            petStore.endHunt()
                            isChoosingHuntMap = false
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                } else if isChoosingHuntMap {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("选择刷怪地图")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Button("返回") {
                                isChoosingHuntMap = false
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }

                        ForEach(HuntMap.allCases) { map in
                            let canEnter = petStore.canEnterHuntMap(map)
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(map.displayName)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                    Text(map.levelText)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    if canEnter == false {
                                        Text("需 \(petStore.minimumLevelToEnter(map)) 级进入")
                                            .font(.caption2)
                                            .foregroundStyle(.red.opacity(0.8))
                                    }
                                }

                                Spacer()

                                Button("前往") {
                                    petStore.selectedHuntMap = map
                                    petStore.hunt()
                                    isChoosingHuntMap = false
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(canEnter == false)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.quaternary.opacity(0.28), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ActionButton(title: "打工", action: {
                            petStore.work()
                        })
                            .disabled(petStore.canPerformAction() == false)
                        ActionButton(title: "刷怪", action: {
                            guard petStore.canPerformAction() else { return }
                            isChoosingHuntMap = true
                        })
                            .disabled(petStore.canPerformAction() == false)
                        ActionButton(title: "拾荒", action: {
                            petStore.scavenge()
                        })
                            .disabled(petStore.canPerformAction() == false)
                        ActionButton(title: petStore.danceButtonTitle, action: {
                            petStore.toggleDance()
                        })
                            .disabled(petStore.isCurrentPetDead)
                    }
                }

                if petStore.isHunting == false {
                    if let deathDescription = petStore.deathDescription {
                        Text(deathDescription)
                            .font(.caption)
                            .foregroundStyle(.red)
                    } else if petStore.petSummary.isEmpty == false {
                        Text(petStore.petSummary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if petStore.lastActionSummary.isEmpty == false {
                        Text(petStore.lastActionSummary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if petStore.battleLog.isEmpty == false {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(petStore.battleLog.suffix(2).enumerated()), id: \.offset) { _, line in
                            let isBattleLine = line.contains("对") && line.contains("造成了")
                            Text("\(isBattleLine ? "【战斗】" : "【信息】")\(line)")
                            .font(.callout)
                            .foregroundStyle(
                                isBattleLine
                                ? Color(red: 0.72, green: 0.38, blue: 0.38)
                                : Color(red: 0.30, green: 0.58, blue: 0.38)
                            )
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(10)
                    .background(.quaternary.opacity(0.18), in: RoundedRectangle(cornerRadius: 10))
                }
            } else {
                Text("先去商店招募一位修仙者。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.24), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.separator.opacity(0.5), lineWidth: 1)
        )
    }

}

private struct WarehousePage: View {
    @ObservedObject var petStore: PetStore
    let closeWarehouse: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button("返回", action: closeWarehouse)
                    .buttonStyle(.bordered)

                Spacer()

                Text("背包")
                    .font(.headline)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 1)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if petStore.ownedInventoryItems.isEmpty && petStore.ownedEquipmentItems.isEmpty {
                        Text("背包空空如也")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        if petStore.ownedInventoryItems.isEmpty == false {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("道具")
                                    .font(.subheadline.weight(.semibold))

                                ForEach(petStore.ownedInventoryItems) { item in
                                    InventoryItemRow(
                                        item: item,
                                        count: petStore.itemCount(for: item),
                                        canUse: petStore.canUse(item)
                                    ) {
                                        petStore.use(item)
                                    }
                                }
                            }
                        }

                        if petStore.ownedEquipmentItems.isEmpty == false {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("装备")
                                    .font(.subheadline.weight(.semibold))

                                ForEach(petStore.ownedEquipmentItems) { item in
                                    EquipmentInventoryRow(
                                        item: item,
                                        count: petStore.equipmentCount(for: item)
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct MerchantPage: View {
    @ObservedObject var petStore: PetStore
    let closeMerchant: () -> Void

    @State private var selectedTab: MerchantTab = .items

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button("返回") {
                    petStore.clearMerchantNoticeIfNeeded()
                    closeMerchant()
                }
                    .buttonStyle(.bordered)

                Spacer()

                Text("游街商贩")
                    .font(.headline)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 1)
            }

            HStack {
                Picker("商店分类", selection: $selectedTab) {
                    ForEach(MerchantTab.allCases) { tab in
                        Text(tab.title).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(width: 140)

                Spacer()
            }
            .frame(height: 34)
            .overlay(alignment: .trailing) {
                if petStore.lastActionSummary.hasPrefix("购买了") || petStore.lastActionSummary.hasPrefix("购买成功") {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                        Text(petStore.lastActionSummary)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                    }
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.green.opacity(0.14), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green.opacity(0.35), lineWidth: 1)
                    )
                    .transition(.opacity)
                }
            }

            if selectedTab == .items {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(InventoryItem.merchantCases) { item in
                            MerchantItemRow(
                                item: item,
                                count: petStore.itemCount(for: item),
                                canBuy: petStore.canBuy(item)
                            ) {
                                petStore.buy(item)
                            }
                        }
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("预留分类")
                        .font(.subheadline)
                    Text("后续功能将在这里补充。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

private enum MerchantTab: String, CaseIterable, Identifiable {
    case items
    case reserved

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .items:
            return "道具"
        case .reserved:
            return "预留"
        }
    }
}

private struct MerchantItemRow: View {
    let item: InventoryItem
    let count: Int
    let canBuy: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(item.icon)
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.displayName)
                    .font(.subheadline)

                Text("\(item.detailText)，已拥有 x\(count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\((item.purchasePrice ?? 0) / 100)金\((item.purchasePrice ?? 0) % 100)银")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("购买", action: action)
                .buttonStyle(.borderedProminent)
                .disabled(canBuy == false)
        }
        .padding(12)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct DetailStatRow: View {
    let title: String
    let value: Int

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .font(.body.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }
}

private struct ActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
    }
}

private struct InventoryItemRow: View {
    let item: InventoryItem
    let count: Int
    let canUse: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(item.icon)
                .font(.system(size: 22))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.displayName)
                    .font(.subheadline)
                Text(item.detailText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("x\(count)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)

            if item.isUsable {
                Button("使用", action: action)
                    .buttonStyle(.bordered)
                    .disabled(canUse == false)
            }
        }
        .padding(10)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct EquipmentInventoryRow: View {
    let item: EquipmentItem
    let count: Int

    var body: some View {
        HStack(spacing: 12) {
            Text(item.icon)
                .font(.system(size: 22))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.displayName)
                    .font(.subheadline)
                Text(item.slotName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("x\(count)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
        .environmentObject(PetStore())
}
