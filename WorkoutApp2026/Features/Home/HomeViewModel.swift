//
//  HomeViewModel.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftUI

@Observable
final class HomeViewModel {
    // MARK: - State
    var muscleGroups: [MuscleGroupDisplay] = []
    var userName: String = "Jann"
    var userInitials: String = "JM"
    var searchQuery: String = ""
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var errorMessage: String?

    // MARK: - Dependencies
    private var exerciseService: ExerciseServiceProtocol?

    // MARK: - Computed Properties

    var greeting: String {
        GreetingHelper.timeBasedGreeting
    }

    var filteredMuscleGroups: [MuscleGroupDisplay] {
        guard !searchQuery.isEmpty else { return muscleGroups }
        return muscleGroups.filter {
            $0.type.displayName.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    // MARK: - Initialization

    init() {
        // Initialize with default data for immediate display
        loadDefaultMuscleGroups()
    }

    func configure(exerciseService: ExerciseServiceProtocol) {
        self.exerciseService = exerciseService
    }

    // MARK: - Actions

    @MainActor
    func loadMuscleGroups() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            if let service = exerciseService {
                let counts = try await service.getExerciseCountsByMuscleGroup()
                muscleGroups = MuscleGroupType.allCases.map { type in
                    MuscleGroupDisplay(
                        type: type,
                        exerciseCount: counts[type] ?? defaultCount(for: type)
                    )
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            // Keep default data on error
        }

        isLoading = false
    }

    @MainActor
    func refresh() async {
        isRefreshing = true
        await loadMuscleGroups()
        isRefreshing = false
    }

    // MARK: - Private Helpers

    private func loadDefaultMuscleGroups() {
        muscleGroups = MuscleGroupType.allCases.map { type in
            MuscleGroupDisplay(
                type: type,
                exerciseCount: defaultCount(for: type)
            )
        }
    }

    private func defaultCount(for type: MuscleGroupType) -> Int {
        switch type {
        case .chest: return 12
        case .back: return 14
        case .shoulders: return 10
        case .arms: return 16
        case .core: return 11
        case .legs: return 18
        case .glutes: return 9
        case .calves: return 6
        }
    }
}

// MARK: - Display Model
struct MuscleGroupDisplay: Identifiable, Equatable {
    let id = UUID()
    let type: MuscleGroupType
    let exerciseCount: Int

    var color: Color { type.color }
    var iconColor: Color { type.iconColor }
    var tag: String { type.tag }
    var tagBackgroundColor: Color { type.tagBackgroundColor }
    var tagTextColor: Color { type.tagTextColor }
    var systemIconName: String { type.systemIconName }

    static func == (lhs: MuscleGroupDisplay, rhs: MuscleGroupDisplay) -> Bool {
        lhs.type == rhs.type && lhs.exerciseCount == rhs.exerciseCount
    }
}
