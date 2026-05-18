//
//  WorkoutApp2026App.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-05.
//

import SwiftUI
import SwiftData

@main
struct WorkoutApp2026App: App {
    @State private var container = DIContainer.shared
    @State private var coordinator = AppCoordinator()

    init() {
        DIContainer.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.container, container)
                .environment(\.appCoordinator, coordinator)
                .environment(container.errorHandler)
                .modelContainer(container.modelContainer)
                .handleErrors(with: container.errorHandler)
        }
    }
}

// MARK: - Root View with Tab Bar
struct RootView: View {
    @Environment(\.appCoordinator) private var coordinator

    var body: some View {
        Group {
            switch coordinator?.selectedTab ?? .home {
            case .home:
                homeStack
            case .history:
                historyStack
            case .build:
                buildStack
            case .profile:
                profileStack
            }
        }
        .background(ColorPalette.backgroundSecondary.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var homeStack: some View {
        NavigationStack(path: homePathBinding) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var historyStack: some View {
        NavigationStack(path: historyPathBinding) {
            HistoryPlaceholderView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var buildStack: some View {
        NavigationStack(path: buildPathBinding) {
            BuildPlaceholderView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var profileStack: some View {
        NavigationStack(path: profilePathBinding) {
            ProfilePlaceholderView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    // MARK: - Bindings

    private var tabSelection: Binding<AppTab> {
        Binding(
            get: { coordinator?.selectedTab ?? .home },
            set: { coordinator?.selectedTab = $0 }
        )
    }

    private var homePathBinding: Binding<NavigationPath> {
        Binding(
            get: { coordinator?.homePath ?? NavigationPath() },
            set: { coordinator?.homePath = $0 }
        )
    }

    private var historyPathBinding: Binding<NavigationPath> {
        Binding(
            get: { coordinator?.historyPath ?? NavigationPath() },
            set: { coordinator?.historyPath = $0 }
        )
    }

    private var buildPathBinding: Binding<NavigationPath> {
        Binding(
            get: { coordinator?.buildPath ?? NavigationPath() },
            set: { coordinator?.buildPath = $0 }
        )
    }

    private var profilePathBinding: Binding<NavigationPath> {
        Binding(
            get: { coordinator?.profilePath ?? NavigationPath() },
            set: { coordinator?.profilePath = $0 }
        )
    }

    // MARK: - Navigation Destinations

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .home:
            HomeView()
        case .exerciseList(let muscleGroup):
            ExerciseListView(muscleGroup: muscleGroup)
        case .exerciseDetail(let id):
            ExerciseDetailPlaceholderView(exerciseId: id)
        case .exerciseSearch:
            Text("Exercise Search")
        case .workoutBuilder:
            Text("Workout Builder")
        case .activeWorkout(let sessionId):
            ActiveWorkoutPlaceholderView(sessionId: sessionId)
                .toolbar(.hidden, for: .tabBar)
        case .routineList:
            Text("Routines")
        case .routineDetail:
            Text("Routine Detail")
        case .history:
            HistoryPlaceholderView()
        case .workoutSummary:
            Text("Workout Summary")
        case .profile:
            ProfilePlaceholderView()
        case .settings:
            Text("Settings")
        case .editProfile:
            Text("Edit Profile")
        }
    }
}

// MARK: - Placeholder Views (to be replaced with real implementations)

struct HistoryPlaceholderView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "clock.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorPalette.primary)

            Text("History")
                .font(Typography.headlineLarge)
                .foregroundColor(ColorPalette.textPrimary)

            Text("Your workout history will appear here")
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorPalette.backgroundSecondary)
    }
}

struct BuildPlaceholderView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorPalette.primary)

            Text("Build a Workout")
                .font(Typography.headlineLarge)
                .foregroundColor(ColorPalette.textPrimary)

            Text("Create custom workouts here")
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorPalette.backgroundSecondary)
    }
}

struct ProfilePlaceholderView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "person.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorPalette.primary)

            Text("Profile")
                .font(Typography.headlineLarge)
                .foregroundColor(ColorPalette.textPrimary)

            Text("Your profile and settings")
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorPalette.backgroundSecondary)
    }
}

struct ExerciseDetailPlaceholderView: View {
    let exerciseId: Int

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("Exercise #\(exerciseId)")
                .font(Typography.headlineLarge)
                .foregroundColor(ColorPalette.textPrimary)

            Text("Exercise details coming soon")
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorPalette.backgroundSecondary)
        .navigationTitle("Exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActiveWorkoutPlaceholderView: View {
    let sessionId: UUID

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 60))
                .foregroundColor(ColorPalette.primary)

            Text("Active Workout")
                .font(Typography.headlineLarge)
                .foregroundColor(ColorPalette.textPrimary)

            Text("Session \(sessionId.uuidString.prefix(8))")
                .font(Typography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorPalette.backgroundSecondary)
        .navigationTitle("Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    RootView()
        .environment(\.appCoordinator, AppCoordinator())
}
