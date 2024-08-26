//
//  PlayerButtonView.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import SwiftUI

struct PlayerButtonView: View {
    let player: Player
    
    var body: some View {
        VStack {
            Text(player.name)
                .font(.title3.bold())
            
            if player.name != "银行" {
                if player.money > 0 {
                    Text("$\(MoneyHelperFunc.formatDecimalToString(player.money))")
                        .kerning(1.0)
                        .foregroundStyle(.secondary)
                } else {
                    Text("$0")
                        .kerning(1.0)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    PlayerButtonView(player: Player(order: 1, name: "Name", money: 0.0))
}
