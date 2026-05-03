//
//  Typography.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

enum Typography {
    // MARK: - Display (App Title - "Build & Burn")
    static let displayLarge = Font.custom("PlayfairDisplay-Bold", size: 32)
        .fallback(Font.system(size: 32, weight: .bold, design: .serif))
    static let displayMedium = Font.custom("PlayfairDisplay-Bold", size: 28)
        .fallback(Font.system(size: 28, weight: .bold, design: .serif))
    static let displaySmall = Font.custom("PlayfairDisplay-Bold", size: 24)
        .fallback(Font.system(size: 24, weight: .semibold, design: .serif))

    // MARK: - Headlines
    static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headlineMedium = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let headlineSmall = Font.system(size: 16, weight: .semibold, design: .rounded)

    // MARK: - Body
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)

    // MARK: - Labels
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 10, weight: .medium, design: .default)

    // MARK: - Caption
    static let caption = Font.system(size: 11, weight: .regular, design: .default)

    // MARK: - Card Specific (from design)
    static let cardTitle = Font.custom("PlayfairDisplay-Bold", size: 17)
        .fallback(Font.system(size: 17, weight: .semibold, design: .serif))
    static let cardSubtitle = Font.system(size: 11, weight: .regular, design: .default)
    static let cardTag = Font.system(size: 10, weight: .medium, design: .default)

    // MARK: - Greeting
    static let greetingLabel = Font.system(size: 11, weight: .medium, design: .default)
}

// MARK: - Font Fallback Extension
extension Font {
    func fallback(_ fallbackFont: Font) -> Font {
        // In a real app, you'd check if the custom font is available
        // For now, we return the system font fallback
        return fallbackFont
    }
}
