//
//  SearchBar.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search exercises..."
    var onSubmit: (() -> Void)? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: Spacing.iconSmall))
                .foregroundColor(ColorPalette.textSecondary)

            // Text Field
            TextField(placeholder, text: $text)
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textPrimary)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit {
                    onSubmit?()
                }

            // Clear Button
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: Spacing.iconSmall))
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
        }
        .padding(.horizontal, Spacing.searchBarPadding)
        .padding(.vertical, Spacing.md)
        .background(ColorPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: Spacing.searchBarCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.searchBarCornerRadius)
                .stroke(isFocused ? ColorPalette.primary : ColorPalette.border, lineWidth: 0.5)
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("bench press"))
    }
    .padding()
    .background(ColorPalette.backgroundSecondary)
}
