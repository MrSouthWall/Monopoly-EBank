//
//  PlayerListScreen.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI
import SwiftData

struct PlayerListScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [Player]
    @Environment(\.dismiss) private var dismiss
    
    // 银行名称
    @State private var bankNmae: String = "默认银行"
    @State private var bankMoney: Double = 1_000_000_000_000
    
    // 新玩家信息
    @State private var playerName: String = ""
    @State private var playerMoney: Decimal = 15000000
    
    @State private var isShowDeleteDataAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("玩家列表") {
                    if players.last?.order ?? 0 != 0 {
                        ForEach(players, id: \.self) { player in
                            if player.order != 0 {
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    Text(String(player.money.formatted()))
                                }
                            }
                        }
                    } else {
                        Text("空")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("添加新玩家") {
                    TextField("玩家名称", text: $playerName)
                    TextField("初始金额", value: $playerMoney, format: .number)
                        .keyboardType(.decimalPad)
                    Button("添加") {
                        let order = (players.last?.order ?? 0) + 1
                        let newPlayer = Player(order: order, name: playerName, money: playerMoney)
                        modelContext.insert(newPlayer)
                    }
                }
                
                Section() {
                    Button("删除全部玩家", role: .destructive) {
                        isShowDeleteDataAlert = true
                    }
                    .alert("是否删除全部玩家", isPresented: $isShowDeleteDataAlert) {
                        Button("确定", role: .destructive) {
                            do {
                                try modelContext.delete(model: Player.self)
                                let bank = Player(order: 0, name: "银行", money: 10000000000)
                                modelContext.insert(bank)
                            } catch {
                                print("删除全部数据出错")
                            }
                        }
                    } message: {
                        Text("此操作会删除所有的玩家数据，并重置银行！")
                    }
                }
            }
            .navigationTitle("设置玩家")
            .toolbar {
                ToolbarItem {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerListScreen()
        .modelContainer(for: Player.self, inMemory: true)
}
