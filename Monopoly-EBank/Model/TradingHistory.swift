//
//  TradingHistory.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/27.
//

import Foundation
import SwiftData

@Model
final class TradingHistory {
    var creationTime: Date
    var payoutPlayerName: String
    var incomePlayerName: String
    var transactionAmount: Decimal
    
    init(creationTime: Date, payoutPlayerName: String, incomePlayerName: String, transactionAmount: Decimal) {
        self.creationTime = creationTime
        self.payoutPlayerName = payoutPlayerName
        self.incomePlayerName = incomePlayerName
        self.transactionAmount = transactionAmount
    }
}
