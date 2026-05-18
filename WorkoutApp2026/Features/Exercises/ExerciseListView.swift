//
//  ExerciseListView.swift
//  WorkoutApp2026
//
//  Created by Codex on 2026-05-03.
//

import SwiftUI

struct ExerciseListView: View {
    @State private var viewModel: ExerciseListViewModel
    @Environment(\.container) private var container
    @Environment(\.appCoordinator) private var coordinator

    init(muscleGroup: MuscleGroupType) {
        _viewModel = State(initialValue: ExerciseListViewModel(muscleGroup: muscleGroup))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ColorPalette.backgroundSecondary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                searchAndFilters
                content
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            startWorkoutBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(ColorPalette.primary, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            viewModel.configure(
                exerciseService: container.exerciseService,
                workoutService: container.workoutService
            )
            await viewModel.loadExercises()
        }
        .refreshable {
            await viewModel.refreshExercises()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .center, spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(viewModel.muscleGroup.color)
                    Image(systemName: viewModel.muscleGroup.systemIconName)
                        .font(.system(size: Spacing.iconLarge, weight: .semibold))
                        .foregroundColor(viewModel.muscleGroup.iconColor)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("\(viewModel.muscleGroup.displayName) day")
                        .font(Typography.displaySmall)
                        .foregroundColor(ColorPalette.textOnPrimary)

                    Text(viewModel.metadataText)
                        .font(Typography.labelMedium)
                        .foregroundColor(ColorPalette.textOnPrimary.opacity(0.78))
                }

                Spacer()
            }

            HStack(spacing: Spacing.sm) {
                Label("\(viewModel.selectedCount) selected", systemImage: "checkmark.circle.fill")
                Label("\(viewModel.plannedSetCount) planned sets", systemImage: "list.bullet.clipboard")
            }
            .font(Typography.labelMedium)
            .foregroundColor(ColorPalette.textOnPrimary.opacity(0.85))
        }
        .padding(.horizontal, Spacing.screenHorizontal)
        .padding(.top, Spacing.md)
        .padding(.bottom, Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorPalette.primary)
    }

    private var searchAndFilters: some View {
        VStack(spacing: Spacing.md) {
            SearchBar(
                text: $viewModel.searchText,
                placeholder: "Search \(viewModel.muscleGroup.displayName.lowercased()) exercises..."
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(ExerciseListViewModel.ExerciseFilter.allCases) { filter in
                        filterChip(filter)
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
            .padding(.horizontal, -Spacing.screenHorizontal)
        }
        .padding(.horizontal, Spacing.screenHorizontal)
        .padding(.top, -Spacing.lg)
        .padding(.bottom, Spacing.md)
    }

    private var content: some View {
        Group {
            if viewModel.isLoading && viewModel.exercises.isEmpty {
                loadingView
            } else if let errorMessage = viewModel.errorMessage, viewModel.exercises.isEmpty {
                errorView(errorMessage)
            } else if viewModel.filteredExercises.isEmpty {
                emptyView
            } else {
                exerciseList
            }
        }
    }

    private var exerciseList: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.listItemSpacing) {
                ForEach(viewModel.filteredExercises, id: \.id) { exercise in
                    ExerciseSelectionCard(
                        exercise: exercise,
                        selection: viewModel.selectedExercise(for: exercise),
                        isExpanded: viewModel.expandedExerciseId == exercise.id,
                        onToggleSelected: {
                            viewModel.toggleSelection(for: exercise)
                        },
                        onToggleExpanded: {
                            viewModel.toggleExpanded(for: exercise)
                        },
                        onIncrementSets: {
                            viewModel.incrementSets(for: exercise)
                        },
                        onDecrementSets: {
                            viewModel.decrementSets(for: exercise)
                        },
                        onIncrementReps: {
                            viewModel.incrementReps(for: exercise)
                        },
                        onDecrementReps: {
                            viewModel.decrementReps(for: exercise)
                        }
                    )
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
            .padding(.top, Spacing.sm)
            .padding(.bottom, viewModel.selectedCount > 0 ? 112 : Spacing.xxxl)
        }
    }

    private var loadingView: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .tint(ColorPalette.primary)
            Text("Loading exercises...")
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(ColorPalette.error)
            Text("Unable to load exercises")
                .font(Typography.headlineSmall)
                .foregroundColor(ColorPalette.textPrimary)
            Text(message)
                .font(Typography.bodySmall)
                .foregroundColor(ColorPalette.textSecondary)
                .multilineTextAlignment(.center)
            Button("Try again") {
                Task { await viewModel.refreshExercises() }
            }
            .font(Typography.labelLarge)
            .foregroundColor(ColorPalette.textOnPrimary)
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.md)
            .background(ColorPalette.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(Spacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(ColorPalette.textTertiary)
            Text(viewModel.emptyStateTitle)
                .font(Typography.headlineSmall)
                .foregroundColor(ColorPalette.textPrimary)
            Text(viewModel.emptyStateMessage)
                .font(Typography.bodySmall)
                .foregroundColor(ColorPalette.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var startWorkoutBar: some View {
        if viewModel.selectedCount > 0 {
            VStack(spacing: Spacing.sm) {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(Typography.caption)
                        .foregroundColor(ColorPalette.error)
                        .lineLimit(2)
                }

                Button {
                    Task {
                        guard let sessionId = await viewModel.startWorkout() else { return }
                        coordinator?.navigate(to: .activeWorkout(sessionId: sessionId))
                    }
                } label: {
                    HStack {
                        if viewModel.isStartingWorkout {
                            ProgressView()
                                .tint(ColorPalette.textOnPrimary)
                        } else {
                            Image(systemName: "play.fill")
                        }

                        Text("Start workout")
                            .font(Typography.headlineSmall)

                        Spacer()

                        Text("\(viewModel.selectedCount) exercises")
                            .font(Typography.labelMedium)
                            .opacity(0.85)
                    }
                    .foregroundColor(ColorPalette.textOnPrimary)
                    .padding(.horizontal, Spacing.lg)
                    .frame(height: 54)
                    .background(viewModel.isStartingWorkout ? ColorPalette.primaryLight : ColorPalette.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(viewModel.isStartingWorkout)
            }
            .padding(.horizontal, Spacing.screenHorizontal)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.md)
            .background(ColorPalette.surface)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(ColorPalette.border)
                    .frame(height: 0.5)
            }
        }
    }

    private func filterChip(_ filter: ExerciseListViewModel.ExerciseFilter) -> some View {
        Button {
            viewModel.selectedFilter = filter
        } label: {
            Text(filter.rawValue)
                .font(Typography.labelMedium)
                .foregroundColor(viewModel.selectedFilter == filter ? ColorPalette.textOnPrimary : ColorPalette.textPrimary)
                .padding(.horizontal, Spacing.md)
                .frame(height: 34)
                .background(viewModel.selectedFilter == filter ? ColorPalette.primary : ColorPalette.surface)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(ColorPalette.border, lineWidth: viewModel.selectedFilter == filter ? 0 : 0.5)
                }
        }
    }
}

private struct ExerciseSelectionCard: View {
    let exercise: SDExercise
    let selection: ExerciseListViewModel.SelectedExercise?
    let isExpanded: Bool
    let onToggleSelected: () -> Void
    let onToggleExpanded: () -> Void
    let onIncrementSets: () -> Void
    let onDecrementSets: () -> Void
    let onIncrementReps: () -> Void
    let onDecrementReps: () -> Void

    private var isSelected: Bool {
        selection != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggleExpanded) {
                HStack(spacing: Spacing.md) {
                    exerciseIcon

                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(exercise.name)
                            .font(Typography.headlineSmall)
                            .foregroundColor(ColorPalette.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        Text(exercise.categoryName ?? "Strength")
                            .font(Typography.bodySmall)
                            .foregroundColor(ColorPalette.textSecondary)

                        if let selection, !isExpanded {
                            Text("\(selection.sets) sets x \(selection.reps) reps")
                                .font(Typography.labelMedium)
                                .foregroundColor(ColorPalette.primary)
                        }
                    }

                    Spacer(minLength: Spacing.sm)

                    Button(action: onToggleSelected) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(isSelected ? ColorPalette.primary : ColorPalette.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(Spacing.lg)
            }
            .buttonStyle(.plain)

            if let selection, isExpanded {
                VStack(spacing: Spacing.md) {
                    Divider()
                        .background(ColorPalette.border)

                    HStack(spacing: Spacing.md) {
                        StepperControl(
                            title: "Sets",
                            value: selection.sets,
                            onDecrement: onDecrementSets,
                            onIncrement: onIncrementSets
                        )

                        StepperControl(
                            title: "Reps",
                            value: selection.reps,
                            onDecrement: onDecrementReps,
                            onIncrement: onIncrementReps
                        )
                    }

                    HStack {
                        Label("Rest estimate", systemImage: "timer")
                        Spacer()
                        Text("\(selection.sets * 90 / 60) min")
                    }
                    .font(Typography.labelMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }
        }
        .background(ColorPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? ColorPalette.primary : ColorPalette.border, lineWidth: isSelected ? 1.5 : 0.5)
        }
    }

    private var exerciseIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorPalette.backgroundTertiary)
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: Spacing.iconLarge))
                .foregroundColor(ColorPalette.primary)
        }
        .frame(width: 48, height: 48)
    }
}

private struct StepperControl: View {
    let title: String
    let value: Int
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    var body: some View {
        HStack(spacing: Spacing.sm) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(Typography.labelMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                Text("\(value)")
                    .font(Typography.headlineMedium)
                    .foregroundColor(ColorPalette.textPrimary)
                    .frame(minWidth: 28, alignment: .leading)
            }

            Spacer()

            HStack(spacing: Spacing.xs) {
                Button(action: onDecrement) {
                    Image(systemName: "minus")
                }
                .buttonStyle(StepperIconButtonStyle())

                Button(action: onIncrement) {
                    Image(systemName: "plus")
                }
                .buttonStyle(StepperIconButtonStyle())
            }
        }
        .padding(Spacing.md)
        .background(ColorPalette.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct StepperIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: Spacing.iconSmall, weight: .bold))
            .foregroundColor(ColorPalette.primary)
            .frame(width: 30, height: 30)
            .background(ColorPalette.surface)
            .clipShape(Circle())
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(muscleGroup: .chest)
            .environment(\.container, DIContainer.shared)
            .environment(\.appCoordinator, AppCoordinator())
    }
}
