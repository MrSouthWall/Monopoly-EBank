//
//  Monopoly_EBankApp.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI
import SwiftData

@main
struct Monopoly_EBankApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Player.self,
            TradingHistory.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
