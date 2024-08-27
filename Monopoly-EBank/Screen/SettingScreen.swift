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
    @Environment(\.dismiss) private var dismiss
    @State private var isShowDeleteDataAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("重置（删除全部数据）") {
                    Button("重新开始游戏", role: .destructive) {
                        isShowDeleteDataAlert = true
                    }
                    .alert("是否删除全部玩家与交易历史", isPresented: $isShowDeleteDataAlert) {
                        Button("确定", role: .destructive) {
                            do {
                                try modelContext.delete(model: Player.self)
                                try modelContext.delete(model: TradingHistory.self)
                                let bank = Player(order: 0, name: "银行", money: 10000000000)
                                modelContext.insert(bank)
                                dismiss()
                            } catch {
                                print("删除全部数据出错")
                            }
                        }
                    } message: {
                        Text("此操作会删除所有的玩家数据和交易历史，并重置银行！")
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingScreen()
}
