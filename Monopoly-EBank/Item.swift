//
//  Item.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
