//
//  Player.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import Foundation
import SwiftData

@Model
final class Player {
    var id: UUID = UUID()
    var order: Int = 0
    var name: String = "None"
    var money: Decimal = 0.0
    var isGoBroke: Bool = false
    
    init(order: Int, name: String, money: Decimal) {
        self.order = order
        self.name = name
        self.money = money
    }
}
