//
//  Color+Hex.swift
//  FriendList
//
//  Created by Phivos Valougeorgis on 25/03/2023.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    static let jaddedGreen = Color(hex: "09AD9F")
    static let appGreen = Color(hex: "4BD762")
    static let iconGray = Color(hex: "C4C4C6")
    static let lineGray = Color(hex: "EEF0F7")
    static let buttonGray = Color(hex: "F2F1F6")
    static let background = Color(hex: "F1F3F9")
    static let textGray = Color(hex: "8A898E")
}

extension Color {
    static let insetListBackground = Color(red: 242, green: 243, blue: 249)
}

