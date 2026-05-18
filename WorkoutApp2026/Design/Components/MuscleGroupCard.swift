//
//  MuscleGroupCard.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

struct MuscleGroupCard: View {
    let muscleGroup: MuscleGroupType
    let exerciseCount: Int
    var onTap: (() -> Void)? = nil

    var body: some View {
        Group {
            if let onTap {
                Button(action: onTap) {
                    cardContent
                }
                .buttonStyle(MuscleCardButtonStyle())
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area with Body Illustration
            ZStack {
                Rectangle()
                    .fill(muscleGroup.color)

                // Body illustration placeholder - using SF Symbol
                Image(systemName: muscleGroup.systemIconName)
                    .font(.system(size: 48))
                    .foregroundColor(muscleGroup.iconColor)
            }
            .frame(height: Spacing.muscleCardImageHeight)

            // Footer with name, count, and tag
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(muscleGroup.displayName)
                        .font(Typography.cardTitle)
                        .foregroundColor(ColorPalette.textPrimary)

                    Text("\(exerciseCount) exercises")
                        .font(Typography.cardSubtitle)
                        .foregroundColor(ColorPalette.textSecondary)
                }

                Spacer()

                // Tag
                Text(muscleGroup.tag)
                    .font(Typography.cardTag)
                    .foregroundColor(muscleGroup.tagTextColor)
                    .padding(.horizontal, Spacing.tagPaddingHorizontal)
                    .padding(.vertical, Spacing.tagPaddingVertical)
                    .background(muscleGroup.tagBackgroundColor)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(muscleGroup.tagTextColor.opacity(0.3), lineWidth: 0.5)
                    )
            }
            .padding(.horizontal, Spacing.cardPadding)
            .padding(.top, Spacing.muscleCardFooterPadding)
            .padding(.bottom, Spacing.cardPadding)
        }
        .background(ColorPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: Spacing.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.cardCornerRadius)
                .stroke(ColorPalette.border, lineWidth: 0.5)
        )
    }
}

// MARK: - Button Style
struct MuscleCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 10) {
            MuscleGroupCard(muscleGroup: .chest, exerciseCount: 12)
            MuscleGroupCard(muscleGroup: .back, exerciseCount: 14)
        }
        HStack(spacing: 10) {
            MuscleGroupCard(muscleGroup: .shoulders, exerciseCount: 10)
            MuscleGroupCard(muscleGroup: .arms, exerciseCount: 16)
        }
    }
    .padding()
    .background(ColorPalette.backgroundSecondary)
}
