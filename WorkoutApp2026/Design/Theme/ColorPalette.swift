//
//  ColorPalette.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

enum ColorPalette {
    // MARK: - Primary Colors (from design mockup)
    static let primary = Color(hex: "D4537E")           // Pink
    static let primaryLight = Color(hex: "E8789A")      // Lighter pink
    static let primaryDark = Color(hex: "B23D64")       // Darker pink

    // MARK: - Background Colors
    static let background = Color(hex: "FFFFFF")        // White
    static let backgroundSecondary = Color(hex: "FBEAF0") // Light pink tint
    static let backgroundTertiary = Color(hex: "FDF5F7")  // Very light pink
    static let surface = Color(hex: "FFFFFF")           // Card backgrounds

    // MARK: - Text Colors
    static let textPrimary = Color(hex: "3A1828")       // Dark plum (from design)
    static let textSecondary = Color(hex: "B88FA0")     // Muted pink (from design)
    static let textTertiary = Color(hex: "D0A0B4")      // Light muted pink
    static let textOnPrimary = Color(hex: "FFFFFF")     // White text on pink

    // MARK: - Border Colors
    static let border = Color(hex: "F0D0DA")            // Light pink border
    static let borderLight = Color(hex: "F4C0D1")       // Very light border

    // MARK: - Muscle Group Card Colors
    static let chestColor = Color(hex: "FBEAF0")        // Light pink
    static let backColor = Color(hex: "EAF3DE")         // Light green
    static let shouldersColor = Color(hex: "E6F1FB")    // Light blue
    static let armsColor = Color(hex: "EEEDFE")         // Light purple
    static let coreColor = Color(hex: "FAEEDA")         // Light yellow/orange
    static let legsColor = Color(hex: "FBEAF0")         // Light pink
    static let glutesColor = Color(hex: "FAECE7")       // Light peach
    static let calvesColor = Color(hex: "E1F5EE")       // Light teal

    // MARK: - Muscle Icon Colors (for the body illustrations)
    static let chestIconColor = Color(hex: "D4537E")    // Pink
    static let backIconColor = Color(hex: "3B6D11")     // Dark green
    static let shouldersIconColor = Color(hex: "185FA5") // Blue
    static let armsIconColor = Color(hex: "534AB7")     // Purple
    static let coreIconColor = Color(hex: "BA7517")     // Orange/brown
    static let legsIconColor = Color(hex: "993556")     // Dark pink
    static let glutesIconColor = Color(hex: "D85A30")   // Orange
    static let calvesIconColor = Color(hex: "0F6E56")   // Teal

    // MARK: - Tag Colors
    static let pushTagBackground = Color(hex: "FBEAF0")
    static let pushTagText = Color(hex: "993556")
    static let pullTagBackground = Color(hex: "EAF3DE")
    static let pullTagText = Color(hex: "27500A")
    static let isoTagBackground = Color(hex: "EEEDFE")
    static let isoTagText = Color(hex: "3C3489")
    static let lowerTagBackground = Color(hex: "FBEAF0")
    static let lowerTagText = Color(hex: "72243E")

    // MARK: - Semantic Colors
    static let success = Color(hex: "10B981")
    static let warning = Color(hex: "F59E0B")
    static let error = Color(hex: "EF4444")
    static let info = Color(hex: "3B82F6")

    // MARK: - Tab Bar
    static let tabBarBackground = Color(hex: "FFFFFF")
    static let tabBarSelected = primary
    static let tabBarUnselected = Color(hex: "D0A0B4")
}

// MARK: - Color Hex Extension
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
            (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
