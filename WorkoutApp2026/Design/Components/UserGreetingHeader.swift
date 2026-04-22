//
//  UserGreetingHeader.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

struct UserGreetingHeader: View {
    let greeting: String
    let userName: String
    var userInitials: String = "JM"
    var onAvatarTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            // Greeting label
            Text(greeting.uppercased())
                .font(Typography.greetingLabel)
                .foregroundColor(ColorPalette.borderLight)
                .tracking(0.8)

            HStack {
                // App title
                Text("Build &")
                    .font(Typography.displayLarge)
                    .foregroundColor(ColorPalette.textOnPrimary)
                +
                Text("\n")
                +
                Text("Burn")
                    .font(Typography.displayLarge)
                    .foregroundColor(ColorPalette.textOnPrimary)

                Spacer()

                // Avatar
                Button(action: { onAvatarTap?() }) {
                    ZStack {
                        Circle()
                            .fill(ColorPalette.primaryDark)
                            .frame(width: Spacing.avatarSize, height: Spacing.avatarSize)

                        Text(userInitials)
                            .font(Typography.labelMedium)
                            .foregroundColor(ColorPalette.backgroundSecondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Standalone Greeting (for other screens)
struct SimpleGreetingHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Text(title)
                .font(Typography.headlineLarge)
                .foregroundColor(ColorPalette.textPrimary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Typography.bodyMedium)
                    .foregroundColor(ColorPalette.textSecondary)
            }
        }
    }
}

// MARK: - Greeting Helper
enum GreetingHelper {
    static var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<21:
            return "Good evening"
        default:
            return "Good night"
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        ZStack {
            ColorPalette.primary
            UserGreetingHeader(
                greeting: "Good morning",
                userName: "Jann"
            )
            .padding()
        }
        .frame(height: 150)

        SimpleGreetingHeader(title: "Exercises", subtitle: "12 exercises")
            .padding()

        Spacer()
    }
}
