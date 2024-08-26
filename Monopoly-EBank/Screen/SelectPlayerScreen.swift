//
//  SelectPlayerScreen.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI
import SwiftData

struct SelectPlayerScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Player.order) private var players: [Player]
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var defaults = Defaults()
    
    // 临时的示例数据
    var playerss: [Player] = [
        Player(order: 1, name: "玩家1",money: 100000),
        Player(order: 2, name: "玩家2", money: 100000),
        Player(order: 3, name: "玩家3", money: 100000),
        Player(order: 4, name: "玩家4",money: 100000),
        Player(order: 5, name: "玩家5", money: 100000),
        Player(order: 6, name: "玩家6", money: 100000),
        Player(order: 7, name: "玩家7", money: 100000),
        Player(order: 8, name: "玩家8", money: 100000),
    ]
    
    // 选择的玩家
    @Binding var aPlayer: [Player]
    @Binding var bPlayer: [Player]
    @Binding var isReverse: Bool
    
    @State private var tapNumber: Int = 0
    @State private var isShowAlertOfGoBroke: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    CardView(
                        currentPlayer: players.first ?? Player(order: 0, name: "银行", money: 10000000000),
                        geometry: geometry,
                        aPlayer: $aPlayer,
                        bPlayer: $bPlayer,
                        tapNumber: $tapNumber,
                        isReverse: $isReverse,
                        isShowGrid: .constant(false),
                        isShowAlertOfGoBroke: $isShowAlertOfGoBroke
                    )
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columnGrid(), spacing: 27, content: {
                        ForEach(players) { player in
                            if player.order != 0 {
                                CardView(currentPlayer: player, geometry: geometry, aPlayer: $aPlayer, bPlayer: $bPlayer, tapNumber: $tapNumber, isReverse: $isReverse, isShowGrid: $defaults.isShowGrid, isShowAlertOfGoBroke: $isShowAlertOfGoBroke)
                                    .onChange(of: tapNumber == 2) {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
                                            dismiss()
                                        }
                                    }
                            }
                        }
                    })
                    .padding()
                }
            }
            .navigationTitle("选择玩家")
            .toolbar {
                Button {
                    withAnimation(.bouncy) {
                        defaults.isShowGrid.toggle()
                    }
                } label: {
                    Image(systemName: defaults.isShowGrid ? "square.grid.2x2.fill" : "square.grid.2x2")
                }
            }
            // 提示，不能选择已破产的玩家
            .overlay {
                Text("无法选择已破产的玩家！")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black)
                    .mask({
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    })
                    .opacity(isShowAlertOfGoBroke ? 0.8 : 0)
                    .animation(.easeInOut, value: isShowAlertOfGoBroke)
                    .offset(x: 0, y: 200)
            }
        }
    }
    
    // 网格列
    func columnGrid() -> [GridItem] {
        return Array(repeating: GridItem(), count: defaults.isShowGrid ? 2 : 1)
    }
}

// MARK: - SubView
struct CardView: View {
    let currentPlayer: Player
    let geometry: GeometryProxy
    
    @Binding var aPlayer: [Player]
    @Binding var bPlayer: [Player]
    @Binding var tapNumber: Int
    @Binding var isReverse: Bool
    @Binding var isShowGrid: Bool
    @Binding var isShowAlertOfGoBroke: Bool
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundStyle(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .stroke(strokeColor(), lineWidth: 5)
                }
            
            PlayerButtonView(player: currentPlayer)
            
            if currentPlayer.isGoBroke == true {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .frame(width: 150, height: 25)
                        .foregroundStyle(.yellow)
                    
                    Text("已破产")
                        .font(.footnote.bold())
                        .foregroundStyle(.red)
                }
                .rotationEffect(.degrees(45))
            }
        }
        // abs用于获取绝对值，解决在视图出现期间，尺寸可能为负数的情况
        .frame(width: isShowGrid ? geometry.size.width / 2.5 : abs(geometry.size.width - 60), height: geometry.size.height / 5)
        .scaleEffect(cardScale())
        .onTapGesture {
            withAnimation(.bouncy) {
                if currentPlayer.isGoBroke == false {
                    tapNumber += 1
                    selectPlayer()
                } else {
                    isShowAlertOfGoBroke = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                        isShowAlertOfGoBroke = false
                    }
                }
            }
        }
    }
    
    // 选择玩家
    func selectPlayer() {
        switch isReverse {
        case false:
            if tapNumber == 1 {
                aPlayer.append(currentPlayer)
            } else if tapNumber == 2 {
                bPlayer.append(currentPlayer)
            }
        case true:
            if tapNumber == 1 {
                bPlayer.append(currentPlayer)
            } else if tapNumber == 2 {
                aPlayer.append(currentPlayer)
            }
        }
    }
    // 描边颜色
    func strokeColor() -> Color {
        switch isReverse {
        case false:
            if aPlayer.first == currentPlayer {
                return .green
            } else if bPlayer.first == currentPlayer {
                return .red
            } else {
                return .gray
            }
        case true:
            if aPlayer.first == currentPlayer {
                return .red
            } else if bPlayer.first == currentPlayer {
                return .green
            } else {
                return .gray
            }
        }
    }
    // 卡片缩放
    func cardScale() -> CGFloat {
        if aPlayer.first == currentPlayer {
            return 1.05
        } else if bPlayer.first == currentPlayer {
            return 1.05
        } else {
            return 1.0
        }
    }
}

#Preview {
    SelectPlayerScreen(aPlayer: .constant([Player(order: 1, name: "Player 1",money: 100000)]), bPlayer: .constant([Player(order: 2, name: "Player 2",money: 100000)]), isReverse: .constant(false))
        .modelContainer(for: Player.self, inMemory: true)
}
