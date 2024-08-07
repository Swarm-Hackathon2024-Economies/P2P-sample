//
//  P2P_sampleApp.swift
//  P2P-sample
//
//  Created by 伊佐治恵介 on 2024/06/18.
//

import SwiftUI
import SwiftData

@main
struct P2P_sampleApp: App {
    @StateObject private var appState = AppState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ConnectionView()
                .environmentObject(appState)
        }
        .onChange(of: ScenePhase.active) {
            if ScenePhase.active == .active {
                appState.isActive = true
            } else {
                appState.isActive = false
            }
        }
    }
}
