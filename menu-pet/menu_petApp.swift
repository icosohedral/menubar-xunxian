//
//  menu_petApp.swift
//  menu-pet
//
//  Created by icosohedral on 2026/4/30.
//

import AppKit
import SwiftUI

@main
struct menu_petApp: App {
    @StateObject private var petStore = PetStore()

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(petStore)
        }
        label: {
            Label("Menu Pet", systemImage: "pawprint.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
