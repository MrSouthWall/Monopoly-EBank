//
//  NumberKeyboardView.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI
import SwiftData

struct NumberKeyboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Player.order) private var players: [Player]
    
    // 输入框内容
    @State private var enterText = ""
    
    // 将字符转换成Decimal的实际金额
    var transactionAmount: Decimal {
        MoneyHelperFunc.stringToDecimal(enterText)
    }
    
    // 选中的玩家
    @Binding var aPlayer: [Player]
    @Binding var bPlayer: [Player]
    
    // 是否反向交易
    let isReverse: Bool
    
    // 检查是否破产
    @Binding var isGoBroke: Bool
    
    let rows = [
        ["M", "起点", "K"],
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "C"],
    ]
    
    var body: some View {
        VStack {
            showAmount()
            
            numberGrid()
            
            tradeButton()
        }
    }
    
    // MARK: Func
    
    // 金额显示
    func showAmount() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(.gray.opacity(0.2))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray.opacity(0.2), lineWidth: 1.0)
                }
            Text(!enterText.isEmpty ? enterText : "输入金额")
                .kerning(2.0)
                .font(.title)
                .foregroundStyle(!enterText.isEmpty ? Color.primary : .gray.opacity(0.2))
        }
        .frame(height: 55)
        .padding(.horizontal)
    }
    
    // 网格列
    func columnGrid() -> [GridItem] {
        return Array(repeating: GridItem(), count: 3)
    }
    
    // 数字网格
    func numberGrid() -> some View {
        LazyVGrid(columns: columnGrid(), spacing: 10) {
            ForEach(rows, id: \.self) { row in
                ForEach(row, id: \.self) { key in
                    Button {
                        enterRule(key: key)
                    } label: {
                        if key != "delete.left.fill" {
                            Text(key)
                                .font(.title2.bold())
                                .frame(width: 110, height: 45)
                                .foregroundColor(key != "C" ? .primary : .white)
                                .background(key != "C" ? Color.gray.opacity(0.2) : .red)
                                .saturation(key != "C" ? 1 : 0.9)
                                .mask {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                                }
                        } else {
                            Image(systemName: key)
                                .font(.title2.bold())
                                .frame(width: 110, height: 45)
                                .foregroundColor(.primary)
                                .background(Color.gray.opacity(0.2))
                                .mask {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                                }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 2)
    }
    
    // 键盘输入规则
    func enterRule(key: String) {
        switch key {
        case "M":
            if enterText.contains("K") {
                enterText.removeLast()
                enterText += "M"
            } else {
                guard enterText.isEmpty else {
                    guard enterText.contains("M") else { return enterText += "M" }
                    return
                }
            }
        case "起点": enterText = "2M"
        case "K":
            if enterText.contains("M") {
                enterText.removeLast()
                enterText += "K"
            } else {
                guard enterText.contains("M") else {
                    guard enterText.isEmpty else {
                        guard enterText.contains("K") else { return enterText += "K" }
                        return
                    }
                    return
                }
            }
        case ".":
            if enterText.contains(where: { unit in
                return unit == "M" || unit == "K"
            }) {
                if !enterText.contains(".") {
                    let index = enterText.index(enterText.endIndex, offsetBy: -1)
                    enterText.insert(contentsOf: key, at: index)
                } else {
                    enterText += ""
                }
            } else if !enterText.isEmpty {
                if !enterText.contains(".") {
                    enterText += "."
                } else {
                    enterText += ""
                }
            } else {
                enterText = "0."
            }
        case "C": enterText.removeAll()
        default:
            if enterText.contains(where: { unit in
                return unit == "M" || unit == "K"
            }) {
                let index = enterText.index(enterText.endIndex, offsetBy: -1)
                enterText.insert(contentsOf: key, at: index)
            } else {
                enterText += key
            }
        }
    }
    
    // 确认交易按钮
    func tradeButton() -> some View {
        Button {
            // 检测两个玩家是否为空
            guard aPlayer.isEmpty || bPlayer.isEmpty || enterText.isEmpty else {
                switch isReverse {
                case false:
                    // 检测支出玩家是否有钱
                    if aPlayer.first!.money < 0 {
                        aPlayer.first!.isGoBroke = true
                        isGoBroke = true
                    } else {
                        players[aPlayer.first!.order].money -= transactionAmount
                        players[bPlayer.first!.order].money += transactionAmount
                        if aPlayer.first!.money < 0 {
                            aPlayer.first!.isGoBroke = true
                            isGoBroke = true
                        }
                    }
                    // 添加交易记录
                    let newTradingHistory = TradingHistory(creationTime: .now, payoutPlayerName: aPlayer.first!.name, incomePlayerName: bPlayer.first!.name, transactionAmount: transactionAmount)
                    modelContext.insert(newTradingHistory)
                    do {
                        try modelContext.save()
                    } catch {
                        print("保存交易历史记录出错")
                    }
                case true:
                    // 检测支出玩家是否有钱
                    if bPlayer.first!.money < 0 {
                        bPlayer.first!.isGoBroke = true
                        isGoBroke = true
                    } else {
                        players[aPlayer.first!.order].money += transactionAmount
                        players[bPlayer.first!.order].money -= transactionAmount
                        if bPlayer.first!.money < 0 {
                            bPlayer.first!.isGoBroke = true
                            isGoBroke = true
                        }
                    }
                    // 添加交易记录
                    let newTradingHistory = TradingHistory(creationTime: .now, payoutPlayerName: bPlayer.first!.name, incomePlayerName: aPlayer.first!.name, transactionAmount: transactionAmount)
                    modelContext.insert(newTradingHistory)
                    do {
                        try modelContext.save()
                    } catch {
                        print("保存交易历史记录出错")
                    }
                }
                enterText = ""
                return
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.green)
                Text("确认交易")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
            .frame(height: 55)
        }
        .disabled(aPlayer.isEmpty || bPlayer.isEmpty || enterText.isEmpty)
    }
}

#Preview {
    NumberKeyboardView(
        aPlayer: .constant([Player(order: 1, name: "玩家A", money: 0.0)]),
        bPlayer: .constant([Player(order: 1, name: "玩家B", money: 0.0)]),
        isReverse: false,
        isGoBroke: .constant(false))
}
