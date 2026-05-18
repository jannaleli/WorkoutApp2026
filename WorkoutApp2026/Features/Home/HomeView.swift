//
//  HomeView.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Environment(\.appCoordinator) private var coordinator
    @Environment(\.container) private var container

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.gridSpacing),
        GridItem(.flexible(), spacing: Spacing.gridSpacing)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Hero Section with Pink Background
            heroSection

            // Search Bar (overlapping hero)
            searchSection

            ScrollView {
                VStack(spacing: 0) {


                    // Section Label
                    sectionLabel

                    // Muscle Group Grid
                    muscleGrid
                }
            }
            .background(ColorPalette.backgroundSecondary)
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                viewModel.configure(exerciseService: container.exerciseService)
                await viewModel.loadMuscleGroups()
            }
        }
        .background(ColorPalette.backgroundSecondary)
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            // Pink background
            ColorPalette.primary
                .frame(height: 140)

            // Content
            VStack(alignment: .leading, spacing: 0) {
                UserGreetingHeader(
                    greeting: viewModel.greeting,
                    userName: viewModel.userName,
                    userInitials: viewModel.userInitials,
                    onAvatarTap: {
                        coordinator?.switchTab(to: .profile)
                    }
                )
            }
            .padding(.horizontal, Spacing.screenHorizontal)
            .padding(.top, Spacing.heroPaddingTop)
            .padding(.bottom, Spacing.heroPaddingBottom + 16) // Extra padding for search overlap
        }
    }

    // MARK: - Search Section
    private var searchSection: some View {
        SearchBar(
            text: $viewModel.searchQuery,
            placeholder: "Search exercises..."
        )
        .padding(.horizontal, Spacing.screenHorizontal)
        .offset(y: -22) // Overlap with hero
    }

    // MARK: - Section Label
    private var sectionLabel: some View {
        Text("CHOOSE A MUSCLE GROUP")
            .font(Typography.greetingLabel)
            .foregroundColor(ColorPalette.textSecondary)
            .tracking(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.screenHorizontal)
            .padding(.top, Spacing.sectionLabelMarginTop - 22) // Adjust for search offset
            .padding(.bottom, Spacing.sectionLabelMarginBottom)
    }

    // MARK: - Muscle Grid
    private var muscleGrid: some View {
        LazyVGrid(columns: columns, spacing: Spacing.gridSpacing) {
            ForEach(viewModel.filteredMuscleGroups) { group in
                NavigationLink(value: Route.exerciseList(muscleGroup: group.type)) {
                    MuscleGroupCard(
                        muscleGroup: group.type,
                        exerciseCount: group.exerciseCount
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.screenHorizontal)
        .padding(.bottom, Spacing.xxxl)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
