//
//  MoneyHelperFunc.swift
//  Monopoly-EBank
//
//  Created by 南墙先生 on 2024/8/26.
//

import Foundation

class MoneyHelperFunc {
    // 格式化Decimal，输出String
    static func formatDecimalToString(_ number: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        var result = ""
        var value = number
        
        if value >= 1_000_000 {
            value = value / 1_000_000
            formatter.maximumFractionDigits = 1
            result = formatter.string(from: NSDecimalNumber(decimal: value) as NSNumber) ?? ""
            result += "M"
        } else if value >= 1_000 {
            value = value / 1_000
            formatter.maximumFractionDigits = 1
            result = formatter.string(from: NSDecimalNumber(decimal: value) as NSNumber) ?? ""
            result += "K"
        } else {
            formatter.maximumFractionDigits = 2
            result = formatter.string(from: NSDecimalNumber(decimal: value) as NSNumber) ?? ""
        }
        
        return result
    }
    // String转Decimal
    static func stringToDecimal(_ string: String) -> Decimal {
        var result: Decimal = 0
        
        if string.contains("M") {
            result = Decimal(string: string.replacingOccurrences(of: "M", with: "")) ?? 0
            result *= 1000000
        } else if string.contains("K") {
            result = Decimal(string: string.replacingOccurrences(of: "K", with: "")) ?? 0
            result *= 1000
        } else {
            result = Decimal(string: string) ?? 0
        }
        
        return result
    }
}
