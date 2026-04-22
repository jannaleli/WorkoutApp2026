//
//  CustomTabBar.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    var onTabSelected: ((AppTab) -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        selectedTab = tab
                        onTabSelected?(tab)
                    }
                )
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.tabBarPadding)
        .padding(.bottom, Spacing.xxxl)
        .background(
            ColorPalette.tabBarBackground
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: -5)
        )
    }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                // Special treatment for Build tab (center, larger)
                if tab == .build {
                    ZStack {
                        Circle()
                            .fill(ColorPalette.primary)
                            .frame(width: 56, height: 56)

                        Image(systemName: tab.iconName)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(ColorPalette.textOnPrimary)
                    }
                    .offset(y: -10)
                } else {
                    Image(systemName: isSelected ? tab.iconName : tab.iconNameInactive)
                        .font(.system(size: Spacing.tabBarIconSize))
                        .foregroundColor(isSelected ? ColorPalette.tabBarSelected : ColorPalette.tabBarUnselected)

                    Text(tab.title)
                        .font(Typography.labelSmall)
                        .foregroundColor(isSelected ? ColorPalette.tabBarSelected : ColorPalette.tabBarUnselected)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.home))
    }
    .background(ColorPalette.backgroundSecondary)
}
