//
//  ContentView.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var petStore: PetStore
    @State private var currentPage: Page = .care

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if currentPage == .care {
                CarePanel(
                    petStore: petStore,
                    openWarehouse: { currentPage = .warehouse },
                    openMerchant: { currentPage = .merchant }
                )
            } else if currentPage == .warehouse {
                WarehousePage(
                    petStore: petStore,
                    closeWarehouse: { currentPage = .care },
                    didSwitchPet: {
                        currentPage = .care
                    }
                )
            } else {
                MerchantPage(
                    petStore: petStore,
                    closeMerchant: { currentPage = .care }
                )
            }
        }
        .padding(16)
        .frame(width: 390)
    }

    private var header: some View {
        HStack {
            Label("\(petStore.coins) 金币", systemImage: "coin")
                .font(.headline)
            Spacer()
            Text("已拥有 \(petStore.ownedPets.count)/3 只")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private enum Page {
    case care
    case warehouse
    case merchant
}

private struct CarePanel: View {
    let petStore: PetStore
    let openWarehouse: () -> Void
    let openMerchant: () -> Void
    @State private var isRenamingPet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Text(petStore.petIcon)
                        .font(.system(size: 42))

                    Text(petStore.petMoodEmoji)
                        .font(.system(size: 18))
                        .padding(4)
                        .background(.background, in: Circle())
                        .offset(x: 8, y: -8)
                }
                .padding(.trailing, 8)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Button {
                            if petStore.ownedPets.isEmpty == false {
                                isRenamingPet.toggle()
                            }
                        } label: {
                            Text(petStore.petName)
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)

                        if petStore.ownedPets.isEmpty == false {
                            Button("背包", action: openWarehouse)
                                .buttonStyle(.bordered)
                        }

                        Button("宠物商人", action: openMerchant)
                            .buttonStyle(.bordered)
                    }

                    Text(petStore.petSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(petStore.petSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            if petStore.ownedPets.isEmpty == false {
                if isRenamingPet {
                    TextField(
                        "给当前宠物起名字",
                        text: Binding(
                            get: { petStore.currentPetCustomName },
                            set: { petStore.renameCurrentPet($0) }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                }
            }

            VStack(spacing: 12) {
                StatRow(title: "心情", value: petStore.mood, tint: .pink)
                StatRow(title: "饱食度", value: petStore.satiety, tint: .orange)
                StatRow(title: "精力", value: petStore.energy, tint: .blue)
                StatRow(title: "亲密", value: petStore.affection, tint: .green)
            }

            HStack(spacing: 8) {
                ActionButton(title: "喂食", action: {
                    petStore.feed(.essence)
                })
                .disabled(petStore.canFeed(.essence) == false)
                ActionButton(title: "玩耍", action: petStore.play)
            }
            .disabled(petStore.currentPet == nil || petStore.isCurrentPetWorking)

            HStack(spacing: 8) {
                ActionButton(title: "睡觉", action: petStore.sleep)
                ActionButton(title: "抚摸", action: petStore.pet)
            }
            .disabled(petStore.currentPet == nil || petStore.isCurrentPetWorking)

            VStack(alignment: .leading, spacing: 8) {
                ActionButton(title: petStore.workButtonTitle, action: petStore.work)
                    .disabled(petStore.canStartWork() == false)
            }

        }
    }
}

private struct WarehousePage: View {
    let petStore: PetStore
    let closeWarehouse: () -> Void
    let didSwitchPet: () -> Void
    @State private var selectedTab: WarehouseTab = .pets

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

            Picker("背包分类", selection: $selectedTab) {
                ForEach(WarehouseTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)

            if selectedTab == .pets {
                PetWarehousePanel(petStore: petStore) {
                    didSwitchPet()
                }
            } else {
                SpiritInventoryView(petStore: petStore)
            }
        }
    }
}

private struct MerchantPage: View {
    let petStore: PetStore
    let closeMerchant: () -> Void

    @State private var selectedTab: MerchantTab = .pets

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button("返回", action: closeMerchant)
                    .buttonStyle(.bordered)

                Spacer()

                Text("宠物商人")
                    .font(.headline)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 1)
            }

            Picker("商店分类", selection: $selectedTab) {
                ForEach(MerchantTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)

            if selectedTab == .pets {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(PetType.allCases) { type in
                            MerchantPetRow(
                                type: type,
                                isOwned: petStore.owns(type),
                                canBuy: petStore.canBuy(type),
                                salePrice: type.salePrice,
                                action: {
                                    petStore.buy(type)
                                },
                                sellAction: {
                                petStore.sellPet(of: type)
                                }
                            )
                        }
                    }
                }
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(SpiritGrade.allCases) { grade in
                            MerchantSpiritRow(
                                grade: grade,
                                count: petStore.spiritCount(for: grade),
                                canBuy: petStore.canBuySpirit(grade)
                            ) {
                                petStore.buySpirit(grade)
                            }
                        }

                        SpiritInventoryView(petStore: petStore)
                    }
                }
            }
        }
    }
}

private struct PetWarehousePanel: View {
    let petStore: PetStore
    let didSwitchPet: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("宠物")
                .font(.headline)

            if petStore.ownedPets.isEmpty {
                Text("当前还没有宠物")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(petStore.ownedPets) { pet in
                            PetWarehouseRow(
                                pet: pet,
                                isCurrent: pet.id == petStore.selectedPetID
                            ) {
                                petStore.selectedPetID = pet.id
                                didSwitchPet()
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
    }
}

private enum WarehouseTab: String, CaseIterable, Identifiable {
    case pets
    case items

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .pets:
            return "宠物"
        case .items:
            return "道具"
        }
    }
}

private struct PetWarehouseRow: View {
    let pet: PetState
    let isCurrent: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(pet.type.icon)
                .font(.system(size: 30))

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(pet.customName.isEmpty ? pet.type.displayName : pet.customName)
                        .font(.subheadline)

                    if isCurrent {
                        Text("当前")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.green.opacity(0.18), in: Capsule())
                    }
                }

                Text(pet.type.speciesName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(isCurrent ? "已选择" : "切换") {
                action()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isCurrent)
        }
        .padding(12)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
    }
}

private enum MerchantTab: String, CaseIterable, Identifiable {
    case pets
    case items

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .pets:
            return "宠物"
        case .items:
            return "道具"
        }
    }
}

private struct MerchantPetRow: View {
    let type: PetType
    let isOwned: Bool
    let canBuy: Bool
    let salePrice: Int
    let action: () -> Void
    let sellAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(type.icon)
                .font(.system(size: 30))

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(type.displayName)
                        .font(.subheadline)
                    if isOwned {
                        Text("已拥有")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.secondary.opacity(0.15), in: Capsule())
                    }
                }

                Text(type.speciesName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isOwned {
                Text("可出售 \(salePrice) 金币")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("出售", action: sellAction)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.96, green: 0.65, blue: 0.72))
            } else {
                Text("\(type.purchasePrice) 金币")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("购买", action: action)
                    .buttonStyle(.borderedProminent)
                    .disabled(canBuy == false)
            }
        }
        .padding(12)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct MerchantSpiritRow: View {
    let grade: SpiritGrade
    let count: Int
    let canBuy: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(grade.icon)
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 3) {
                Text(grade.displayName)
                    .font(.subheadline)

                Text("恢复 \(grade.satietyRecovery) 饱食度，已拥有 x\(count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(grade.purchasePrice) 金币")
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

private struct StatRow: View {
    let title: String
    let value: Int
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value)")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: Double(value), total: 100)
                .tint(tint)
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

private struct SpiritInventoryView: View {
    let petStore: PetStore

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("精魄库存")
                .font(.subheadline)

            ForEach(SpiritGrade.allCases) { grade in
                HStack {
                    Text("\(grade.icon) \(grade.displayName)")
                    Spacer()
                    Text("x\(petStore.spiritCount(for: grade))")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
        }
        .padding(10)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
        .environmentObject(PetStore())
}
