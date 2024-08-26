//
//  SettingScreen.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI
import SwiftData

struct SettingScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink {
                    PlayerListScreen()
                } label: {
                    Text("重新开始游戏！")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingScreen()
}
