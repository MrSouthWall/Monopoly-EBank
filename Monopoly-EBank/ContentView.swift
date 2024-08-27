//
//  ContentView.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Player.order) private var players: [Player]
    
    // 选中的玩家
    @State private var aPlayer: [Player] = []
    @State private var bPlayer: [Player] = []
    
    // 是否反向交易
    @State private var isReverse = false
    // 是否显示页面
    @State private var isShowSetting = false
    @State private var isShowPlayList = false
    
    // 破产提示
    @State private var isGoBroke = false
    
    var body: some View {
        NavigationStack {
            VStack {
                selectPlayer()
                
                Spacer()
                
                NumberKeyboardView(aPlayer: $aPlayer, bPlayer: $bPlayer, isReverse: isReverse, isGoBroke: $isGoBroke)
            }
            .navigationTitle("桌游电子银行")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("玩家列表", systemImage: "list.bullet") {
                        isShowPlayList = true
                    }
                    .sheet(isPresented: $isShowPlayList, content: {
                        PlayerListScreen()
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("设置", systemImage: "gear") {
                        isShowSetting = true
                    }
                    .sheet(isPresented: $isShowSetting, content: {
                        SettingScreen()
                    })
                }
            }
            .alert("玩家“\(aPlayer.first?.name ?? "None")”已破产！", isPresented: $isGoBroke) {
                Button("Ok") { }
            }
        }
    }
    
    // MARK: Func
    
    // 玩家选择器
    func selectPlayer() -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundStyle(.gray.opacity(0.2))
            
            HStack {
                // 已选择的A玩家
                NavigationLink {
                    SelectPlayerScreen(aPlayer: $aPlayer, bPlayer: $bPlayer, isReverse: $isReverse)
                        .onAppear(perform: {
                            aPlayer.removeAll()
                            bPlayer.removeAll()
                        })
                } label: {
                    playerButton(player: "A")
                }
                
                Spacer()
                
                Button {
                    isReverse.toggle()
                } label: {
                    Image(systemName: isReverse ? "arrow.left" : "arrow.right")
                        .font(.title.bold())
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                // 已选择的B玩家
                NavigationLink {
                    SelectPlayerScreen(aPlayer: $aPlayer, bPlayer: $bPlayer, isReverse: $isReverse)
                        .onAppear(perform: {
                            aPlayer.removeAll()
                            bPlayer.removeAll()
                        })
                } label: {
                    playerButton(player: "B")
                }
            }
        }
        .frame(maxHeight: 130)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    
    // 玩家按钮
    @ViewBuilder func playerButton(player: String) -> some View {
        switch player {
        case "A":
            ZStack {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .foregroundStyle(.background)
                    .frame(width: 100, height: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                            .stroke(!isReverse ? .green : .red, lineWidth: 5.0)
                    }
                
                PlayerButtonView(player: aPlayer.first ?? Player(order: 1, name: "选择玩家", money: 0.0))
                    .foregroundStyle(aPlayer.first != nil ? Color(uiColor: .label) : .gray.opacity(0.5))
            }
            .padding(.leading, 15)
            
        case "B":
            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .foregroundStyle(.background)
                    .frame(width: 100, height: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                            .stroke(!isReverse ? .red : .green, lineWidth: 5.0)
                    }
                
                PlayerButtonView(player: bPlayer.first ?? Player(order: 1, name: "选择玩家", money: 0.0))
                    .foregroundStyle(bPlayer.first != nil ? Color(uiColor: .label) : .gray.opacity(0.5))
            }
            .padding(.trailing, 15)
            
        default:
            Text("玩家选择错误！")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Player.self, inMemory: true)
}
