//
//  Defaults.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import Foundation
import SwiftUI

class Defaults: ObservableObject {
    // 以网格显示
    @AppStorage("isShowGrid") public var isShowGrid: Bool = true
}
