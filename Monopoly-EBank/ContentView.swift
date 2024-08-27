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
    @Query(sort: \TradingHistory.creationTime, order: .reverse) private var tradingHistorys: [TradingHistory]
    
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
                
                tradingHistory()
                
                Spacer()
                
                NumberKeyboardView(aPlayer: $aPlayer, bPlayer: $bPlayer, isReverse: isReverse, isGoBroke: $isGoBroke)
            }
            .navigationTitle("大富翁电子银行")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("重置游戏", systemImage: "gear") {
                        isShowSetting = true
                    }
                    .sheet(isPresented: $isShowSetting, content: {
                        SettingScreen()
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("添加玩家", systemImage: "plus") {
                        isShowPlayList = true
                    }
                    .sheet(isPresented: $isShowPlayList, content: {
                        PlayerListScreen()
                    })
                }
            }
            .alert("玩家“\(aPlayer.first?.name ?? "None")”已破产！", isPresented: $isGoBroke) {
                Button("Ok") { }
            }
        }
        .onAppear {
            if players.isEmpty {
                do {
                    try modelContext.delete(model: Player.self)
                    try modelContext.delete(model: TradingHistory.self)
                    let bank = Player(order: 0, name: "银行", money: 10000000000)
                    modelContext.insert(bank)
                    print("游戏首次启动，已完成银行初始化！")
                } catch {
                    print("删除全部数据出错")
                }
            } else {
                print("游戏内已有银行，不进行初始化！")
            }
        }
    }
    
    // MARK: Func
    
    // 玩家选择器
    func selectPlayer() -> some View {
        
        ZStack {
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
                    withAnimation {
                        Image(systemName: "arrow.right")
                            .rotationEffect(isReverse ? .degrees(-180) : .degrees(0))
                            .font(.title.bold())
                            .foregroundStyle(Color(uiColor: .label))
                    }
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
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 5)
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
    
    /// 交易历史记录视图
    func tradingHistory() -> some View {
        List {
            ForEach(tradingHistorys) { item in
                let transactionAmount = MoneyHelperFunc.formatDecimalToString(item.transactionAmount)
                HStack {
                    Text(item.creationTime.formatted(date: .omitted, time: .standard))
                        .frame(alignment: .leading)
                    Text(item.payoutPlayerName)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "arrow.right")
                        .bold()
                        .frame(maxWidth: 25, alignment: .center)
                    Text(item.incomePlayerName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(transactionAmount) 元")
                        .frame(alignment: .trailing)
                }
            }
        }
        .listStyle(.plain)
        .padding(.bottom, 5)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Player.self, inMemory: true)
}
